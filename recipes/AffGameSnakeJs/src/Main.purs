module AffGameSnakeJs.Main where

import Prelude

import Color (Color, black, white)
import Color.Scheme.Clrs (green, red)
import Control.Monad.Rec.Loops (iterateWhile)
import Data.Array.NonEmpty (NonEmptyArray, cons, cons', dropEnd, head, singleton)
import Data.Int (toNumber)
import Data.Maybe (Maybe(..), maybe)
import Data.Traversable (elem, for_)
import Data.Tuple.Nested ((/\))
import Data.Vector.Polymorphic (Vector2, makeRect, (><))
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Exception (throw)
import Game.Aff (AffGame, FPS(..), launchGame_, mkAffGame, mkReducer)
import Game.Aff.AnimationFrame (animationFrameMatchInterval)
import Game.Aff.Web.Event (_keyboardEvent, documentEventTarget, keydown)
import Game.Util (asksAt)
import Graphics.Canvas (Context2D, getCanvasElementById, getContext2D, setCanvasDimensions)
import Graphics.CanvasAction (class MonadCanvasAction, fillRect, filled, liftCanvasAction)
import Graphics.CanvasAction.Run (CANVAS, runCanvas)
import Random.LCG (randomSeed)
import Run.State (get, modify)
import Test.QuickCheck.Gen (Gen, GenState, chooseInt, runGen)
import Web.DOM.Document (createElement)
import Web.DOM.Element (setAttribute, setId)
import Web.DOM.Element as Element
import Web.DOM.Node (appendChild, setTextContent)
import Web.HTML (window)
import Web.HTML.HTMLDocument as HTMLDocument
import Web.HTML.HTMLElement as HTMLElement
import Web.HTML.Window (document)
import Web.UIEvent.KeyboardEvent (key)

-- CONSTANTS
--
xmax :: Int
xmax = 25

ymax :: Int
ymax = 25

cellSize :: Int
cellSize = 10

cellSizeNum :: Number
cellSizeNum = toNumber cellSize

ticksPerSecond :: Number
ticksPerSecond = 12.0

-- Using opposite colors for the bg and the snake, so it's a little different
-- from the Signal version.
snakeColor :: Color
snakeColor = black

bgColor :: Color
bgColor = white

foodColor :: Color
foodColor = red

wallColor :: Color
wallColor = green

-- STATE MODEL AND TYPES
--
type Point = Vector2 Int

data Direction
  = Left
  | Right
  | Up
  | Down

derive instance eqDirection :: Eq Direction

type Snake
  = NonEmptyArray Point

-- The type of our game state
type Model
  = { food :: Point
    , snake :: Snake
    , direction :: Direction
    , genState :: GenState
    }

-- Some initial state values
initialDirection :: Direction
initialDirection = Right

initialSnake :: Snake
initialSnake = singleton (1 >< 1)

-- Actions that can change our state.
data Action
  = Tick
  | SetDir Direction

--- UPDATE
--
-- How we update our model with each Action.
-- For example, changing direction or moving a step.
update :: Action -> Model -> Model
update (SetDir d) m = m { direction = d }
update Tick m =
  let
    -- Determine where snake head will move
    nextPoint = head m.snake + getMove m.direction

    -- Check if next move will kill snake
    willDie = outOfBounds nextPoint || ateTail nextPoint m.snake

    -- Check if next move will eat food
    willEat = nextPoint == m.food
  in
    case willDie, willEat of
      -- Snake died. Reset snake to starting size and position.
      true, _ -> m { snake = initialSnake, direction = initialDirection }
      -- Snake still alive, but did not find food. Move snake without growing.
      false, false -> m { snake = moveSnakeNoGrow nextPoint m.snake }
      -- Snake still alive, and found food.
      false, true ->
        let
          -- Grow and move snake
          biggerSnake = moveSnakeAndGrow nextPoint m.snake
          -- Find next random food location
          food /\ genState = runGen (availableRandomPoint biggerSnake) m.genState
        in
          m
            { snake = biggerSnake
            , food = food
            , genState = genState
            }

-- Convert direction to a change in coordinates
getMove :: Direction -> Point
getMove = case _ of
  Left -> (-1 >< 0)
  Right -> (1 >< 0)
  Up -> (0 >< -1)
  Down -> (0 >< 1)

-- Check if Point (Snake head) is out of bounds
outOfBounds :: Point -> Boolean
outOfBounds (x >< y) = x <= 0 || y <= 0 || x > xmax || y > ymax

-- Check if Snake ate its tail
ateTail :: Point -> Snake -> Boolean
ateTail = elem

-- Add Point to beginning of Snake
moveSnakeAndGrow :: Point -> Snake -> Snake
moveSnakeAndGrow = cons

-- Add Point to beginning of Snake, and remove the last Point
moveSnakeNoGrow :: Point -> Snake -> Snake
moveSnakeNoGrow pt s = cons' pt $ dropEnd 1 s

-- RANDOM
--
-- Generate a random food location
randomPoint :: Gen Point
randomPoint = do
  x <- chooseInt 1 xmax
  y <- chooseInt 1 ymax
  pure (x >< y)

{- Generate a random food location that's not
currently occupied by the Snake.
It's possible that this guess-and-check strategy
may stall the game loop with lots of unlucky guesses.
A more deterministic strategy is to fist find all
unoccupied points, and then randomly choose from those.
But for small snakes, this simple approach is fine.
-}
availableRandomPoint :: Snake -> Gen Point
availableRandomPoint s = iterateWhile (_ `elem` s) randomPoint

-- RENDERING
--
drawPoint :: forall m. MonadCanvasAction m => Color -> Point -> m Unit
drawPoint color (x >< y) = liftCanvasAction do
  filled color do
    fillRect $ makeRect
      (cellSizeNum * toNumber x)
      (cellSizeNum * toNumber y)
      cellSizeNum
      cellSizeNum

{-
Note that we're currently keeping things simple and re-rendering
the entire canvas from scratch from each state.
We could be more efficient and just overwrite the cells
that change, but that increases complexity.
-}
render :: forall m. MonadCanvasAction m => Model -> m Unit
render m = liftCanvasAction do
  -- Walls
  filled wallColor do
    -- If we want a rectangle to be drawn at (0, 0), we can pass a `Vector2`
    -- containing just the dimensions, to `fillRect`. This works because of
    -- `Vector2`s `ToRegion` instance:
    -- https://pursuit.purescript.org/packages/purescript-polymorphic-vectors/1.1.1/docs/Data.Vector.Polymorphic.Class#v:toRegionVector2
    fillRect
      $  cellSizeNum * toNumber (xmax + 2)
      >< cellSizeNum * toNumber (ymax + 2)
  -- Interior
  filled bgColor do
    fillRect $ makeRect
      cellSizeNum
      cellSizeNum
      (cellSizeNum * toNumber xmax)
      (cellSizeNum * toNumber ymax)
  -- Snake
  for_ m.snake (drawPoint snakeColor)
  -- Food
  drawPoint foodColor m.food


-- AFFGAME
--

{-
We're using the `CANVAS` effect (from `Graphics.CanvasAction.Run`) to draw to
the canvas. We note this in the type of `AffGame`, aliasing it as `Extra` for
convenience.
-}
type Extra = (canvas :: CANVAS)

{-
We're using `Unit` as our environment, since we don't have any resources or
constants we need in our game that requires `Effect` or `Aff` to acquire.
-}
type Env = Unit

game :: AffGame Extra Unit
game = mkAffGame
  -- We generate the apple position and the generator state in the
  -- initialization of the game, and put them in the initial state
  { init: liftEffect do
      -- Setup first piece of random food
      newSeed <- randomSeed
      let
        -- You may hardcode a constant seed value for an
        -- identical sequence of pseudorandom food locations
        -- on each page refresh.
        -- newSeed = mkSeed 42
        initialGenState = { newSeed, size: 1 }

        -- Run generator to get food location
        food /\ genState = runGen (availableRandomPoint initialSnake) initialGenState

        initState =
          { food
          , genState
          , snake: initialSnake
          , direction: initialDirection
          }
      pure
        { env:       unit      :: Env
        -- We're using our `Model` type as the state of the game.
        , initState: initState :: Model
        }
  , updates:
    -- We have a `keydown` update that updates the state with the direction we
    -- pressed
    [ keydown documentEventTarget do
        mDir <- asksAt _keyboardEvent $ key >>> case _ of
          "ArrowLeft"  -> Just Left
          "ArrowUp"    -> Just Up
          "ArrowRight" -> Just Right
          "ArrowDown"  -> Just Down
          _ -> Nothing
        for_ mDir \dir -> modify (update (SetDir dir))
    -- We also have an update that runs at our `ticksPerSecond` interval,
    -- but approximated to the closest (future) animation frame. We simply
    -- update the state, then read it again and render it to the canvas.
    , animationFrameMatchInterval (pure $ FPS ticksPerSecond) do
        modify (update Tick)
        get >>= render
    ]
  }



-- MAIN
--
main :: Effect Unit
main = do
  -- Get canvas context to render into
  ctx <- getRenderNode
  -- Run our game in `Effect`. This is where we tell the game how to handle
  -- the `CANVAS` effect we specified as part of the `Extra` type.
  launchGame_ (mkReducer do runCanvas ctx) game

-- HTML WORKAROUND
--
-- Create our HTML and return a canvas to render into.
-- Note that this is much more concise concise if written in HTML,
-- but we need to use this workaround for compatibility with the
-- TryPureScript environment, which doesn't yet allow providing
-- custom HTML.
getRenderNode :: Effect Context2D
getRenderNode = do
  htmlDoc <- document =<< window
  body <- maybe (throw "Could not find body element") pure =<< HTMLDocument.body htmlDoc
  let
    doc = HTMLDocument.toDocument htmlDoc
  noteElem <- createElement "pre" doc
  canvasElem <- createElement "canvas" doc
  setId "canvas" canvasElem
  setAttribute "style" "border: 1px solid black" canvasElem
  let
    bodyNode = HTMLElement.toNode body

    noteNode = Element.toNode noteElem

    canvasNode = Element.toNode canvasElem
  setTextContent
    """
Click on page to set focus.
Use Arrow keys to turn.
"""
    noteNode
  void $ appendChild noteNode bodyNode
  void $ appendChild canvasNode bodyNode
  canvas <- maybe (throw "Could not find canvas") pure =<< getCanvasElementById "canvas"
  let
    width = toNumber $ cellSize * (xmax + 2)
    height = toNumber $ cellSize * (ymax + 2)
  _ <- setCanvasDimensions canvas { height, width }
  ctx <- getContext2D canvas
  pure ctx
