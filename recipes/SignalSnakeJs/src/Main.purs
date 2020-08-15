module SignalSnakeJs.Main where

import Prelude
import Data.Int (toNumber)
import Data.Maybe (Maybe(..), maybe)
import Data.Traversable (elem, for)
import Test.QuickCheck.Gen (Gen, GenState, chooseInt, runGen)
import Color (Color, black, toHexString, white)
import Color.Scheme.Clrs (green, red)
import Control.Monad.Rec.Loops (iterateWhile)
import Data.Array.NonEmpty (NonEmptyArray, cons, cons', dropEnd, head, singleton)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Exception (throw)
import Graphics.Canvas (Context2D, fillPath, getCanvasElementById, getContext2D, rect, setFillStyle)
import Random.LCG (randomSeed)
import Signal (Signal, constant, dropRepeats, filterMap, foldp, runSignal, sampleOn)
import Signal.DOM (animationFrame, keyPressed)
import Signal.Time (every, second)
import Web.DOM.Document (createElement)
import Web.DOM.Element (setAttribute, setId)
import Web.DOM.Element as Element
import Web.DOM.Node (appendChild, setTextContent)
import Web.HTML (window)
import Web.HTML.HTMLDocument as HTMLDocument
import Web.HTML.HTMLElement as HTMLElement
import Web.HTML.Window (document)

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

snakeColor :: Color
snakeColor = white

bgColor :: Color
bgColor = black

foodColor :: Color
foodColor = red

wallColor :: Color
wallColor = green

-- STATE MODEL AND TYPES
--
type Point
  = { x :: Int
    , y :: Int
    }

-- Convenience function for creating points
p :: Int -> Int -> Point
p x y = { x, y }

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
initialSnake = singleton $ p 1 1

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
  Left -> p (-1) 0
  Right -> p 1 0
  Up -> p 0 (-1)
  Down -> p 0 1

-- Check if Point (Snake head) is out of bounds
outOfBounds :: Point -> Boolean
outOfBounds { x, y } = x <= 0 || y <= 0 || x > xmax || y > ymax

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
  pure { x, y }

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
drawPoint :: Point -> Color -> Context2D -> Effect Unit
drawPoint { x, y } color ctx = do
  setFillStyle ctx $ toHexString color
  fillPath ctx
    $ rect ctx
        { x: cellSizeNum * toNumber x
        , y: cellSizeNum * toNumber y
        , width: cellSizeNum
        , height: cellSizeNum
        }

{-
Note that we're currently keeping things simple and re-rendering
the entire canvas from scratch from each state.
We could be more efficient and just overwrite the cells
that change, but that increases complexity.
-}
render :: Context2D -> Model -> Effect Unit
render ctx m = do
  -- Walls
  setFillStyle ctx $ toHexString wallColor
  fillPath ctx
    $ rect ctx
        { x: 0.0
        , y: 0.0
        , width: cellSizeNum * toNumber (xmax + 2)
        , height: cellSizeNum * toNumber (ymax + 2)
        }
  -- Interior
  setFillStyle ctx $ toHexString bgColor
  fillPath ctx
    $ rect ctx
        { x: cellSizeNum
        , y: cellSizeNum
        , width: cellSizeNum * toNumber xmax
        , height: cellSizeNum * toNumber ymax
        }
  -- Snake
  _ <- for m.snake (\x -> drawPoint x snakeColor ctx)
  -- Food
  drawPoint m.food foodColor ctx

-- SIGNALS
--
-- An `Action` signal that fires at our tick rate
sigTicks :: Signal Action
sigTicks = sampleOn period $ constant Tick
  where
  period = every $ second / ticksPerSecond

-- An `Action` signal that fires on arrow key presses.
-- Note that this signal is wrapped in an Effect,
-- so requires some unwrapping to work with.
sigArrowsEff :: Effect (Signal Action)
sigArrowsEff = do
  -- Unwrap effects from each keyPressed call
  left <- keyPressed 37
  right <- keyPressed 39
  up <- keyPressed 38
  down <- keyPressed 40
  -- This block does a few things (describing from back):
  -- * Maps each key's Boolean Signal to a Direction with mapKey.
  -- * Merges all four signals. Note that `<>`/`append` means `merge`.
  -- * Wraps in a SetDir Action
  -- * Wraps in an Effect
  pure $ SetDir
    <$> mapKey Left left
    <> mapKey Right right
    <> mapKey Up up
    <> mapKey Down down

{- Note that this strategy for merging signals only considers the
most recent start of a keypress to determine a single key that
might be pressed.
So if two keys are pressed between frames (within 17ms @ 60Hz),
then the first keystroke will be overwritten and ignored.
A possible solution is to maintain a queue of unhandled
keystrokes, but this increases complexity.
-}
-- Convert a keypress (bool) signal to a Direction signal.
-- Note that Signals must always have a value, so initialDirection
-- is used here to provide a signal value at time = 0.
mapKey :: Direction -> Signal Boolean -> Signal Direction
mapKey dir sig = filterMap (fromBool dir) initialDirection sig

-- Helper function for mapKey's filterMap.
-- Convert's a Boolean to a Maybe using a default value.
fromBool :: forall a. a -> Boolean -> Maybe a
fromBool x b
  | b = Just x
  | otherwise = Nothing

-- Combine ticks with effectful keypress
sigActionEff :: Effect (Signal Action)
sigActionEff = do
  sigArrows <- sigArrowsEff
  pure $ sigArrows <> sigTicks

-- MAIN
--
main :: Effect Unit
main = do
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

    initialState =
      { food
      , genState
      , snake: initialSnake
      , direction: initialDirection
      }
  --
  -- Setup signals
  sigAction <- sigActionEff
  sigFrame <- animationFrame
  let
    -- Signal representing current state of our Model
    -- based on applying all actions from the past.
    sigState = foldp update initialState sigAction

    -- These next two signals are optional enhancements.
    -- You could alternatively experiment with just rendering
    -- sigState or sigStateAtFrame.
    -- -----------
    -- Capture state at every animation frame. This limits
    -- updates to 60 Hz (or whatever your refresh rate is),
    -- and prevents multiple rerenders within the same frame.
    -- A consequence of this strategy is that the signal fires
    -- at exactly this rate, even when state is unchanged.
    sigStateAtFrame = sampleOn sigFrame sigState

    -- Skip rerenders when state is unchanged
    sigStateAtFrameDedup = dropRepeats sigStateAtFrame
  --
  -- Rendering
  -- Get canvas context to render into
  ctx <- getRenderNode
  -- Apply render function to our signal
  runSignal $ map (render ctx) sigStateAtFrameDedup

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
  noteElem <- createElement "pre" doc
  canvasElem <- createElement "canvas" doc
  setId "canvas" canvasElem
  let
    canvasWidth = show $ cellSize * (xmax + 2)
    canvasHeight = show $ cellSize * (ymax + 2)
  setAttribute "width" canvasWidth canvasElem
  setAttribute "height" canvasHeight canvasElem
  setAttribute "style" "border: 1px solid black" canvasElem
  let
    bodyNode = HTMLElement.toNode body

    noteNode = Element.toNode noteElem

    canvasNode = Element.toNode canvasElem
  setTextContent
    """
Click on page to set focus.
Use Arrow keys to change direction of movement.
"""
    noteNode
  void $ appendChild noteNode bodyNode
  void $ appendChild canvasNode bodyNode
  canvas <- maybe (throw "Could not find canvas") pure =<< getCanvasElementById "canvas"
  ctx <- getContext2D canvas
  pure ctx
