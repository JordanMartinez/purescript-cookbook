module SignalRenderJs.Main where

import Prelude

import Control.Apply (lift2)
import Data.Maybe (Maybe(..), maybe)
import Effect (Effect)
import Effect.Exception (throw)
import Signal (Signal, constant, dropRepeats, foldp, merge, runSignal, sampleOn)
import Signal.DOM (animationFrame, keyPressed)
import Signal.Time (every)
import Web.DOM (Node)
import Web.DOM.Document (createElement)
import Web.DOM.Element as Element
import Web.DOM.Node (appendChild, setTextContent)
import Web.HTML (window)
import Web.HTML.HTMLDocument as HTMLDocument
import Web.HTML.HTMLElement as HTMLElement
import Web.HTML.Window (document)

-- Model is the type of our application state.
-- We track a direction to move on each tick,
-- and our position.
type Model
  = { dir :: Dir
    , pos :: Int
    }

initialState :: Model
initialState = {pos: 0, dir: Right}

data Dir
  = Left
  | Right

instance showDir :: Show Dir where
  show Left = "Left"
  show Right = "Right"

derive instance eqDir :: Eq Dir

-- Actions that can change our state.
-- (same as Msg type in Elm)
data Action
  = Tick
  | SetDir (Maybe Dir)

-- How we update our model with each Action.
-- For example changing direction or moving a step.
update :: Action -> Model -> Model
update (SetDir Nothing) m = m
update (SetDir (Just d)) m = m {dir = d}
update Tick m = m { pos = m.pos + step m.dir }
  where
    step :: Dir -> Int
    step Left = -1
    step Right = 1

-- An `Action` signal that fires whenever the left or
-- right arrow keys are pressed.
-- Note that this signal is wrapped in an Effect,
-- so requires some unwrapping to work with.
sigArrowsEff :: Effect (Signal Action)
sigArrowsEff =
  let
    f :: Boolean -> Boolean -> Maybe Dir
    f true false = Just Left
    f false true = Just Right
    f _ _ = Nothing
  in
    do
      left <- keyPressed 37
      right <- keyPressed 39
      pure $ SetDir <$> lift2 f left right

-- An `Action` signal that fires 5 times per second
sigTicks :: Signal Action
sigTicks = sampleOn (every 200.0) $ constant Tick

-- Combine ticks with effectful keypress
sigActionEff :: Effect (Signal Action)
sigActionEff = do
  sigArrows <- sigArrowsEff
  pure $ merge sigArrows sigTicks

-- How to render our Model
render :: Node -> Model -> Effect Unit
render node model =
  setTextContent (show model) node

-- Create our HTML and return a node to render into
getRenderNode :: Effect Node
getRenderNode = do
  htmlDoc <- document =<< window
  body <- maybe (throw "Could not find body element") pure =<< HTMLDocument.body htmlDoc
  let
    doc = HTMLDocument.toDocument htmlDoc
  p1Elem <- createElement "p" doc
  p2Elem <- createElement "p" doc
  let
    bodyNode = HTMLElement.toNode body
    p1Node = Element.toNode p1Elem
    p2Node = Element.toNode p2Elem
  setTextContent "Click on page, then press Left or Right arrow keys" p1Node
  void $ appendChild p1Node bodyNode
  void $ appendChild p2Node bodyNode
  pure p2Node

main :: Effect Unit
main = do
  node <- getRenderNode
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
  -- Apply render function to our signal
  runSignal $ map (render node) sigStateAtFrameDedup