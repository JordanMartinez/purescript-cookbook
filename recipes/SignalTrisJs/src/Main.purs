module SignalTrisJs.Main where

import Prelude
import Color (Color, black, toHexString, white)
import Color.Scale (grayscale, sample)
import Color.Scheme.X11 as C
import Control.MonadZero (guard)
import Data.Array ((..))
import Data.Array.NonEmpty (NonEmptyArray, cons', toNonEmpty)
import Data.Foldable (all, any, foldl)
import Data.FoldableWithIndex (foldlWithIndex, traverseWithIndex_)
import Data.FunctorWithIndex (mapWithIndex)
import Data.Int (toNumber)
import Data.Map (Map, empty, insert, keys)
import Data.Map as Map
import Data.Maybe (Maybe(..), maybe)
import Data.Set (Set, filter, size)
import Data.Set as Set
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Exception (throw)
import Graphics.Canvas (Context2D, Rectangle, TextAlign(..), fillPath, fillText, getCanvasElementById, getContext2D, rect, setCanvasDimensions, setFillStyle, setTextAlign)
import Heterogeneous.Mapping (class HMap, hmap)
import Random.LCG (randomSeed)
import Signal (Signal, dropRepeats, filterMap, foldp, runSignal)
import Signal.DOM (animationFrame, keyPressed)
import Test.QuickCheck.Gen (Gen, GenState, elements, runGen)
import Web.DOM.Document (createElement)
import Web.DOM.Element (setId)
import Web.DOM.Element as Element
import Web.DOM.Node (appendChild)
import Web.HTML (window)
import Web.HTML.HTMLDocument as HTMLDocument
import Web.HTML.HTMLElement as HTMLElement
import Web.HTML.Window (document)

-- CONSTANTS
--
width :: Int
width = 14

height :: Int
height = 25

cellSize :: Int
cellSize = 16

-- negative space border
cellBorder :: Int
cellBorder = 1

-- number of cells-worth of space around main board
boardBorder :: Int
boardBorder = 3

canvasWidth :: Int
canvasWidth = (width + 2 * boardBorder) * cellSize

canvasHeight :: Int
canvasHeight = (height + 4) * cellSize

-- Your monitor's refresh rate in Hz.
-- This is used to scale game speed.
-- Make this number smaller to increase difficulty.
refreshRate :: Int
refreshRate = 60

pieces :: NonEmptyArray Tile
pieces =
  cons'
    (piece [ p 0 0, p 1 0, p 0 1, p 1 1 ] C.green)
    [ piece [ p (-1) 0, p 0 0, p 1 0, p 2 0 ] C.maroon
    , piece [ p (-1) 0, p 0 0, p 1 0, p 1 1 ] C.mediumblue
    , piece [ p (-1) 0, p 0 0, p 1 0, p 0 1 ] C.teal
    , piece [ p (-1) 0, p 0 0, p 1 1, p 0 1 ] C.purple
    ]
  where
  -- Convenience functions for creating points and pieces
  p :: Int -> Int -> Point
  p x y = { x, y }

  piece :: Array Point -> Color -> Tile
  piece indices color =
    { cells: Set.fromFoldable indices
    , color
    }

-- Where pieces are dropped into the board
initialOffset :: Point
initialOffset = { x: width / 2 - 1, y: 0 }

-- STATE MODEL AND TYPES
--
type Point
  = { x :: Int, y :: Int }

data Direction
  = Left
  | Right
  | Rotate
  | Down

derive instance eqDirection :: Eq Direction

type Board
  = Map Point Color

type Tile
  = { cells :: Set Point
    , color :: Color
    }

type ActiveTile
  = { tile :: Tile
    , offset :: Point
    }

type Model
  = { activeTile :: ActiveTile
    , nextTile :: Tile
    , board :: Board
    , score :: Int
    , frameCounter :: Int
    , status :: Status
    , genState :: GenState
    }

data Status
  = GameOver
  | Running

derive instance eqStatus :: Eq Status

-- Helper function to round-up the result of
-- truncating integer division
ceilDiv :: Int -> Int -> Int
ceilDiv n d = (n + d - 1) / d

-- Actions that can change our state.
data Action
  = Frame
  | Move Direction

--- UPDATE
--
-- How we update our model with each Action.
-- For example, changing direction or moving a step.
update :: Action -> Model -> Model
-- Do nothing when game is over
update _ m@{ status: GameOver } = m

-- Decrement frame counter if not yet ready to advance game state
update Frame m@{ frameCounter }
  | frameCounter > 0 = m { frameCounter = frameCounter - 1 }

-- Advance game state on this frame
update Frame m =
  let
    -- Recalculate number of frames before next update.
    -- The game speed is proportional to score to increase difficulty over time.
    -- Moves per second:
    --   Minimum: 2
    --   Maximum: 20
    -- 16 is a magic number for how to adjust difficulty based on score
    rr = refreshRate

    frameCounter = max (rr / 20) $ min (rr / 2) $ ceilDiv (16 * rr) (m.score + 1)

    -- Make a tile that's moved down by one
    movedTile = moveTile Down m.activeTile
  in
    if fitsInBoard movedTile m.board then
      -- Move tile
      m { activeTile = movedTile, frameCounter = frameCounter }
    else
      -- Cannot move down anymore
      let
        -- Add active tile to board
        -- Note, annotateSet and union is likey faster than foldl and insert.
        newBoard = foldl (\mp k -> Map.insert k m.activeTile.tile.color mp) m.board $ offsetPoints m.activeTile

        -- Clear completed rows
        { board: flushedBoard, score: newScore } = flushBoard { board: newBoard, score: m.score }

        -- Get next tile from pseudorandom generator
        nextTile /\ genState = runGen tileGenerator m.genState

        -- Apply initial tile offset to create the next "active tile"
        newActiveTile = { tile: m.nextTile, offset: initialOffset }
      in
        if fitsInBoard newActiveTile flushedBoard then
          m
            { activeTile = newActiveTile
            , nextTile = nextTile
            , board = flushedBoard
            , score = newScore + 1
            , frameCounter = frameCounter
            , genState = genState
            }
        else
          m { status = GameOver, frameCounter = frameCounter }

-- A User's movement Action
update (Move d) m =
  let
    -- Apply Move to tile
    movedTile = moveTile d m.activeTile
  in
    -- Update active tile if the move is valid
    if fitsInBoard movedTile m.board then
      m { activeTile = movedTile }
    else
      -- Move is invalid, do nothing
      m

-- Apply a move defined by Direction to a tile
moveTile :: Direction -> ActiveTile -> ActiveTile
moveTile = case _ of
  Rotate -> rotateTile
  Down -> translateTile { x: 0, y: 1 }
  Left -> translateTile { x: (-1), y: 0 }
  Right -> translateTile { x: 1, y: 0 }
  where
  -- Change tile offset
  translateTile :: Point -> ActiveTile -> ActiveTile
  translateTile p t = t { offset = t.offset + p }

  -- Rotate a tile 90 degrees
  rotateTile :: ActiveTile -> ActiveTile
  rotateTile at = at { tile { cells = Set.map rotatePoint at.tile.cells } }

  -- Rotate a point around the origin by 90 degrees
  rotatePoint :: Point -> Point
  rotatePoint { x, y } = { x: -y, y: x }

-- Returns true if the tile is in bounds and not overlapping with existing cells
fitsInBoard :: ActiveTile -> Board -> Boolean
fitsInBoard activeTile board =
  let
    -- Get the actual set of points
    points = offsetPoints activeTile

    -- Check if in bounds
    allInBounds = all inBounds points

    -- Check for intersection
    overlaps = any (\k -> Map.member k board) points
  in
    allInBounds && not overlaps

-- Check if point is within board boundaries
inBounds :: Point -> Boolean
inBounds { x, y } = 0 <= x && x < width && 0 <= y && y < height

-- Get a Tile's points with an offset applied
offsetPoints :: ActiveTile -> Set Point
offsetPoints at = Set.map (add at.offset) at.tile.cells

{-
flushBoard (and helpers) can be written more efficiently.
Currently:
  * The board is fully refiltered for each row to find full rows.
  * The board is fully remapped for each row to collapse rows.
An improved algorithm would:
  * Make a single pass to find full rows
  * Build remapping table
  * Perform board remapping on single pass
But this is not a big performance issue for tiny boards, so leaving as-is for now.
-}
type BoardAndScore
  = { board :: Board
    , score :: Int
    }

flushBoard :: BoardAndScore -> BoardAndScore
flushBoard = foldl (>>>) identity (map flushRow (2 .. (height - 1)))

flushRow :: Int -> BoardAndScore -> BoardAndScore
flushRow y m@{ board, score } =
  if width == countRow y board then
    { board: mapKeys' (collapse y) board, score: score + width }
  else
    m

countRow :: Int -> Board -> Int
countRow y board = size (filter (\p -> p.y == y) (keys board))

collapse :: Int -> Point -> Maybe Point
collapse y p
  | (p.y == y) = Nothing
  | (p.y < y) = Just { x: p.x, y: p.y + 1 }
  | otherwise = Just p

mapKeys' :: forall j k v. Ord j => Ord k => (k -> Maybe j) -> Map k v -> Map j v
mapKeys' f m =
  foldlWithIndex
    ( \k out v -> case f k of
        Just k' -> insert k' v out
        Nothing -> out
    )
    empty
    m

-- RANDOM
--
-- Should just be able to remove `toNonEmpty` once this issue is tackled
-- https://github.com/purescript/purescript-quickcheck/issues/109
tileGenerator :: Gen Tile
tileGenerator = elements $ toNonEmpty pieces

-- RENDERING
--
render :: Context2D -> Model -> Effect Unit
render ctx m = do
  displayBackground ctx m.board
  displayTile ctx m.activeTile.tile m.activeTile.offset
  displayTile ctx m.nextTile { x: width - 3, y: height + 1 }
  --
  -- score
  setTextAlign ctx AlignLeft
  setFillStyleC ctx white
  fillTextInt ctx (show m.score) (boardBorder * cellSize) ((height + 2) * cellSize)
  --
  case m.status of
    Running -> do
      pure unit
    GameOver -> do
      fillTextInt ctx "game over" (boardBorder * cellSize) ((height + 3) * cellSize)

displayBackground :: Context2D -> Board -> Effect Unit
displayBackground ctx board = do
  -- canvas background
  setFillStyleC ctx $ sample grayscale 0.2
  fillPath ctx
    $ rectInt ctx
        { x: 0
        , y: 0
        , width: canvasWidth
        , height: canvasHeight
        }
  -- board background
  setFillStyleC ctx black
  fillPath ctx
    $ rectInt ctx
        { x: boardBorder * cellSize
        , y: 0
        , width: width * cellSize
        , height: height * cellSize
        }
  -- nextTile background
  fillPath ctx
    $ rectInt ctx
        { x: (width + boardBorder - 5) * cellSize
        , y: (height + 1) * cellSize
        , width: 5 * cellSize
        , height: 2 * cellSize
        }
  plotCells ctx board

displayTile :: Context2D -> Tile -> Point -> Effect Unit
displayTile ctx tile offset = do
  let
    shiftedCells = Set.map (add offset) tile.cells

    coloredCells = annotateSet (const tile.color) shiftedCells
  plotCells ctx coloredCells

plotCells :: Context2D -> Board -> Effect Unit
plotCells ctx = traverseWithIndex_ (drawCell ctx)

drawCell :: Context2D -> Point -> Color -> Effect Unit
drawCell ctx { x, y } color = do
  setFillStyleC ctx color
  fillPath ctx
    $ rectInt ctx
        { x: (x + boardBorder) * cellSize + cellBorder
        , y: y * cellSize + cellBorder
        , width: cellSize - 2 * cellBorder
        , height: cellSize - 2 * cellBorder
        }

-- Convenience wrappers for canvas functions
--
-- A wrapper for `rect` that accepts a `Rectangle` where the fields
-- are `Int` rather than `Number`.
rectInt ::
  forall intRect.
  HMap (Int -> Number) intRect Rectangle =>
  Context2D -> intRect -> Effect Unit
rectInt ctx r = rect ctx $ hmap toNumber r

-- Wrapper with Int, rather than Number params
fillTextInt :: Context2D -> String -> Int -> Int -> Effect Unit
fillTextInt ctx txt x y = fillText ctx txt (toNumber x) (toNumber y)

-- Wrapper to use Color instead of String
setFillStyleC :: Context2D -> Color -> Effect Unit
setFillStyleC ctx = setFillStyle ctx <<< toHexString

-----------------
-- Faster versions of these functions are proposed in
-- https://github.com/purescript/purescript-ordered-collections/pull/21
toMap :: forall a. Ord a => Set a -> Map a Unit
toMap = foldl (\m k -> Map.insert k unit m) mempty

annotateSet :: forall a b. Ord a => (a -> b) -> Set a -> Map a b
annotateSet f = mapWithIndex (\k _ -> f k) <<< toMap

-- SIGNALS
--
-- An `Action` signal that fires on arrow key presses.
-- Note that this signal is wrapped in an Effect,
-- so it requires some unwrapping to work with.
sigArrowsEff :: Effect (Signal Action)
sigArrowsEff = do
  -- Unwrap effects from each keyPressed call
  left <- keyPressed 37
  right <- keyPressed 39
  up <- keyPressed 38
  down <- keyPressed 40
  -- This block does a few things (describing from back):
  -- * Maps each key's Boolean Signal to a Direction with mapKeypress.
  -- * Merges all four signals. Note that `<>`/`append` means `merge`.
  -- * Wraps in a Move Action
  -- * Wraps in an Effect
  pure $ Move
    <$> mapKeypress Left left
    <> mapKeypress Right right
    <> mapKeypress Rotate up
    <> mapKeypress Down down

-- Convert a keypress (bool) signal to a Direction signal.
-- Note that Signals must always have a value, so aritrarily
-- choosing Down as the signal value at time = 0.
mapKeypress :: Direction -> Signal Boolean -> Signal Direction
mapKeypress dir sig = filterMap (\b -> guard b $> dir) Down sig

-- MAIN
--
main :: Effect Unit
main = do
  -- Generate initial random tiles
  newSeed <- randomSeed
  let
    -- You may hardcode a constant seed value for an
    -- identical sequence of pseudorandom tiles on
    -- each page refresh.
    -- newSeed = mkSeed 42
    initialGenState = { newSeed, size: 1 }

    -- Run generator to get first two tiles
    tile /\ genState1 = runGen tileGenerator initialGenState

    nextTile /\ genState = runGen tileGenerator genState1

    (initialState :: Model) =
      { activeTile:
          { offset: initialOffset
          , tile
          }
      , nextTile
      , board: empty
      , score: 0
      , frameCounter: 0
      , status: Running
      , genState
      }
  --
  -- Setup signals
  -- Unwrap effectful signals
  sigArrows <- sigArrowsEff
  sigAnimationFrame <- animationFrame
  let
    -- Convert animation frame signal to a Frame Action signal
    -- by replacing its Time payload
    sigFrame = map (const Frame) sigAnimationFrame

    -- Merge Action signals together
    sigAction = sigArrows <> sigFrame

    -- Signal representing current state of our Model
    -- based on applying all actions from the past.
    sigState = foldp update initialState sigAction

    -- Skip rerenders when state is unchanged.
    -- Ignore frame counter when checking for duplication
    sigStateDedup = dropRepeats $ map (_ { frameCounter = 0 }) sigState
  --
  -- Rendering
  -- Get canvas context to render into
  ctx <- getRenderNode
  -- Apply render function to our signal
  runSignal $ map (render ctx) sigStateDedup

-- HTML WORKAROUND
--
-- Create our HTML and return a canvas to render into.
-- Note that this much more concise concise if written in HTML,
-- but we need to use this workaround for compatibility with the
-- TryPureScript environment, which doesn't yet allow providing
-- custom HTML.
getRenderNode :: Effect Context2D
getRenderNode = do
  htmlDoc <- document =<< window
  body <- maybe (throw "Could not find body element") pure =<< HTMLDocument.body htmlDoc
  let
    doc = HTMLDocument.toDocument htmlDoc
  canvasElem <- createElement "canvas" doc
  setId "canvas" canvasElem
  let
    bodyNode = HTMLElement.toNode body

    canvasNode = Element.toNode canvasElem
  void $ appendChild canvasNode bodyNode
  canvas <- maybe (throw "Could not find canvas") pure =<< getCanvasElementById "canvas"
  setCanvasDimensions canvas { width: toNumber canvasWidth, height: toNumber canvasHeight }
  ctx <- getContext2D canvas
  pure ctx
