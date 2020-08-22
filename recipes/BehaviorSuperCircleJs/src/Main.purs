module BehaviorSuperCircleJs.Main where

import Prelude

import Color (black, graytone, rotateHue, white)
import Color.Scheme.MaterialDesign (red)
import Control.Apply (lift3)
import Data.Int (toNumber)
import Data.Maybe (Maybe(..), maybe)
import Data.Set (Set, member)
import Data.Time.Duration (Seconds(..))
import Effect (Effect)
import Effect.Exception (throw)
import FRP.Behavior (Behavior, animate, fixB)
import FRP.Behavior.Keyboard (keys)
import FRP.Behavior.Time (seconds)
import FRP.Event.Keyboard (Keyboard, getKeyboard)
import Graphics.Canvas (Context2D, getCanvasElementById, getContext2D, setCanvasDimensions)
import Graphics.Drawing (Color, Drawing, Shape, OutlineStyle, arc, circle, fillColor, filled, lineWidth, outlineColor, outlined, rectangle, render, rotate, text, translate)
import Graphics.Drawing.Font (font, monospace)
import Math (cos, floor, sin, tau, (%))
import Web.DOM.Document (createElement)
import Web.DOM.Element (setId)
import Web.DOM.Element as Element
import Web.DOM.Node (appendChild)
import Web.HTML (window)
import Web.HTML.HTMLDocument as HTMLDocument
import Web.HTML.HTMLElement as HTMLElement
import Web.HTML.Window (document)

{- UPDATE -}

-- | Round a number down to the nearest whole multiple another number. We're
-- | firing new obstacles every 2 seconds, so we can use this to work out when
-- | the last one fired.

downToNearest :: Number -> Number -> Number
downToNearest big small
  = floor (big / small) * small

-- | Given a timestamp, we can work out the rotation of the obstacle. All
-- | obstacles are 270-degree arcs, so we know that anything in the 90 degrees
-- | before the rotation will be clear of the obstacle!

timestampToObstacleRotation :: Number -> Number
timestampToObstacleRotation time
  = (17.0 * time) % tau

-- | "Normalise" a rotation such that it falls within 0.0 and 360.0, by adding
-- | or subtracting 360.0 as necessary.

normalise :: Number -> Number
normalise rotation
  = ((rotation % tau) + tau) % tau

-- | Given the cursor's rotation, would it avoid the obstacle at its given
-- | rotation? This is our simplified form of "collision detection".

avoidsObstacle :: Number -> Number -> Boolean
avoidsObstacle cursor obstacleStartTime
  = if upperBound > lowerBound
      then normalisedCursor < upperBound
        && normalisedCursor > lowerBound

      else normalisedCursor > lowerBound
        || normalisedCursor < upperBound
  where
    normalisedCursor :: Number
    normalisedCursor
      = normalise cursor

    upperBound :: Number
    upperBound
      = timestampToObstacleRotation obstacleStartTime

    lowerBound :: Number
    lowerBound
      = normalise (upperBound - tau / 4.0)

-- | You can turn 0 or 1 into -1 or 1 by multiplying by 2 and taking 1. We'd
-- | also like to generate some pseudo-randomness, so we multiply by one prime
-- | and divide by another before doing (score % 2). The idea here is that it
-- | should at least _seem_ random.

scoreToDirection :: Number -> Number
scoreToDirection score'
  = 2.0 * (((score' * 31.0) % 17.0) % 2.0) - 1.0

-- | Every time we want to render a frame, we should update state accordingly.
-- | To do this, we calculate the new score (if it has changed), new position
-- | of the cursor (if it has changed), and where to draw the obstacle.

update :: Seconds -> Maybe Controls -> State -> State
update (Seconds timestamp) control previous
  = { timestamp
    , cursorRotation: normalise cursorRotation
    , gameRotation: normalise gameRotation
    , score:
        if nextObstacleTriggered
          then
            if cursorRotation `avoidsObstacle` lastObstacleStart
              then previous.score + 1
              else 0
          else
            previous.score
    }

  where
    -- The value of the score as a number, because we need it more than once.
    scoreAsNumber :: Number
    scoreAsNumber
      = toNumber previous.score

    -- The "game" will rotate as the user's score increases, and this is the
    -- number that does it!
    gameRotation :: Number
    gameRotation
      = previous.gameRotation
      + 0.1 * (scoreToDirection scoreAsNumber * scoreAsNumber * changeInTime)

    -- What is our new rotation?
    cursorRotation :: Number
    cursorRotation
      = previous.cursorRotation + changeInRotation

    -- How much time has passed since we last rendered?
    changeInTime :: Number
    changeInTime
      = timestamp - previous.timestamp

    -- How much has our rotation changed since last render?
    changeInRotation :: Number
    changeInRotation
      = changeInTime * tau * controlToVelocity control

    -- When did last render's obstacle fire?
    lastObstacleStart :: Number
    lastObstacleStart
      = previous.timestamp `downToNearest` 2.0

    -- When did _this_ render's obstacle fire?
    currentObstacleStart :: Number
    currentObstacleStart
      = timestamp `downToNearest` 2.0

    -- Given those last two values, has a new obstacle fired?
    nextObstacleTriggered :: Boolean
    nextObstacleTriggered
       = currentObstacleStart /= lastObstacleStart

{- PAINT -}

-- | Constants
size :: Number
size = 400.0

halfSize :: Number
halfSize = size / 2.0

eighthSize :: Number
eighthSize = size / 8.0

-- | Given the timestamp, we need to work out how "wide" we should draw the
-- | obstacle. This function does some ugly maths to tell us just that.

timestampToObstacleRadius :: Number -> Number
timestampToObstacleRadius time
  = eighthSize + remainder * size * 3.0 / 16.0
  where
    -- 2.0 is "brand new", 0.0 is "just finished"
    remainder :: Number
    remainder = 2.0 - (time % 2.0)

-- | The background of our application will always be the same: a purely-white
-- | rectangle covering the entire canvas, with a circle in the middle to show
-- | the "path" of the cursor.

background :: Drawing
background
  = backdrop <> guideline
  where
    -- The backdrop is just behind everything else, and we only draw it to
    -- cover up whatever was drawn in the last frame.
    backdrop
      = filled
          (fillColor white)
          (rectangle 0.0 0.0 size size)

    -- The guideline shows the path of the cursor, but never actually moves.
    guideline
      = outlined
          (outlineColor (graytone 0.8))
          (circle halfSize halfSize eighthSize)

-- | Given the value of the score, produce the display: simple text in the
-- | top-right of the canvas.

score :: Int -> Drawing
score value
  = text (font monospace 12 mempty) (size * 0.75) eighthSize
      (fillColor black) (show value)

-- | Given the cursor's current rotation, we can work out where to draw it on
-- | the canvas using a little bit of trigonometry.

rotationToCursorPosition :: Number -> { x :: Number, y :: Number }
rotationToCursorPosition rotation
  = { x: halfSize + eighthSize * cos rotation
    , y: halfSize + eighthSize * sin rotation
    }

-- | Rotation is usually around the origin, which isn't really what we want. To
-- | solve this problem, we translate our centre to the origin, perform the
-- | rotation, and then translate back.

rotateAroundCentre :: Number -> Drawing -> Drawing
rotateAroundCentre angle
    = translate halfSize halfSize
  <<< rotate angle
  <<< translate (-halfSize) (-halfSize)

-- | Given all the information we calculated in the `update` function, we can
-- | now work out what we want to draw for the next render frame in our game's
-- | display.

paint :: State -> Drawing
paint state
   = background <> score state.score <> rotateGame (cursor <> obstacle)
  where
    -- Where to draw the cursor.
    coordinates :: { x :: Number, y :: Number }
    coordinates
      = rotationToCursorPosition state.cursorRotation

    -- By how much to rotate the game.
    rotateGame :: Drawing -> Drawing
    rotateGame
      = rotateAroundCentre state.gameRotation

    -- This is some nonsense to make the colour change for extra jazziness.
    obstacleColor :: Color
    obstacleColor
      = rotateHue (10.0 * (state.timestamp % 36.0)) red

    -- Centre the obstacle and rotate accordingly.
    positionObstacle :: Drawing -> Drawing
    positionObstacle
        = translate halfSize halfSize
      <<< rotate (timestampToObstacleRotation obstacleStart)

    -- When did this obstacle start?
    obstacleStart :: Number
    obstacleStart
      = state.timestamp `downToNearest` 2.0

    -- How big is it now?
    obstacleRadius :: Number
    obstacleRadius
      = timestampToObstacleRadius state.timestamp

    -- The actual obstacle shape
    obstacleArc :: Shape
    obstacleArc
      = arc 0.0 0.0 0.0 (tau * 0.75) obstacleRadius

    -- Styling for the obstacle
    obstacleStyle :: OutlineStyle
    obstacleStyle
      = outlineColor obstacleColor <> lineWidth 6.0

    -- All together now!
    obstacle :: Drawing
    obstacle
      = positionObstacle (outlined obstacleStyle obstacleArc)

    -- The cursor that we move
    cursor :: Drawing
    cursor
      = filled
          (fillColor (graytone 0.5))
          (circle coordinates.x coordinates.y 10.0)

{- STATE -}

-- | The state holds the timestamp of the latest repaint, the rotation of the
-- | cursor at that moment, and the score. We need the timestamp to work out,
-- | given a control, _how far_ the cursor needs to move per rendered frame.

type State
  = { timestamp      :: Number
    , cursorRotation :: Number
    , gameRotation   :: Number
    , score          :: Int
    }

-- | Initial state will be no great surprise to anyone. The timestamp doesn't
-- | really matter, as we're redrawing immediately. Rotation could be any
-- | value, so why not 0? As for the score, we'll of course start at 0.

initialState :: State
initialState
  = { timestamp:      0.0
    , cursorRotation: 0.0
    , gameRotation:   0.0
    , score:          0
    }

{- CONTROLS -}

-- | These are all the controls we need! "What if we're not going anywhere?"
-- | Well, we can use `Maybe` to say "we're either making a move, or doing
-- | `Nothing`"!

data Controls
  = Anticlockwise
  | Clockwise

-- | When we get the set of currently-pressed keys, we'll want to figure out
-- | what move the user is trying to make. This function reports, based on the
-- | keys pressed, what move the user wants to make (if any!).

keysToControls :: Set String -> Maybe Controls
keysToControls keys
  | "ArrowLeft" `member` keys = Just Anticlockwise
  | "ArrowRight" `member` keys = Just Clockwise
  | otherwise            = Nothing

-- | Applying the above function to the stream of pressed keys gives us a
-- | stream of desired controls.

controls :: Keyboard -> Behavior (Maybe Controls)
controls keyboard
  = map keysToControls (keys keyboard)

-- | Given that we're maybe making a move, we need to convert this move into a
-- | "velocity". Honestly, I couldn't think of a better word for this: we're
-- | trying to express, per second, how many full clockwise rotations the
-- | cursor can do.  A negative number means we'll move anticlockwise.

controlToVelocity :: Maybe Controls -> Number
controlToVelocity = case _ of
  Just Anticlockwise -> -1.0
  Just Clockwise     ->  1.0
  Nothing            ->  0.0

{- MAIN -}

-- | The application loop uses some weird-looking functions. Here, we're
-- | getting the _fixed point_ of a state stream. What this really means is,
-- | we're going to calculate each iteration of state using the one before it.
-- | Of course, we'll also need the current time and the controls the user has
-- | pressed. lift3 takes an `a -> b -> c -> d` function and transforms it into
-- | a `Behavior a -> Behavior b -> Behavior c -> Behavior d` function. Here,
-- | we only apply two of those to `update` - `seconds` and `controls`. The
-- | third argument is the state stream, so we can access previous state.

loop :: Keyboard -> Behavior State
loop keyboard
  = fixB initialState (lift3 update seconds (controls keyboard))

-- | Once we've got a stream of state updates, we can just apply each iteration
-- | to the `paint` function to get each frame of our animation. `map` takes an
-- | `a -> b` and transforms it into a `Behavior a -> Behavior b` function.

renderLoop :: Keyboard -> Behavior Drawing
renderLoop keyboard
  = map paint (loop keyboard)

-- | The `main` function is our application's entry point: this is the function
-- | that gets executed to run our javascript, so everything must stem from
-- | here :)

main :: Effect Unit
main = do
  -- Grab the keyboard to thread through to 'controls'.
  keyboard <- getKeyboard

  -- Grab canvas context for rendering.
  ctx <- getRenderNode

  -- Animate the canvas!
  _ <- animate (renderLoop keyboard) (render ctx)

  pure unit -- We're done!

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
  canvasElem <- createElement "canvas" $ HTMLDocument.toDocument htmlDoc
  setId "canvas" canvasElem
  void $ appendChild (Element.toNode canvasElem) (HTMLElement.toNode body)
  canvas <- maybe (throw "Could not find canvas") pure =<< getCanvasElementById "canvas"
  _ <- setCanvasDimensions canvas { height: size, width: size}
  getContext2D canvas
