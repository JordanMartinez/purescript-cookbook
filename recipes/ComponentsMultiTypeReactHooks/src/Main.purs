module ComponentsMultiTypeReactHooks.Main where

import Prelude
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Tuple (fst)
import Effect (Effect)
import Effect.Exception (throw)
import React.Basic.DOM (render)
import React.Basic.DOM as R
import React.Basic.DOM.Events (targetValue)
import React.Basic.Events (EventHandler, handler, handler_)
import React.Basic.Hooks
  ( Component
  , Hook
  , UseState
  , component
  , useState
  , useState'
  , (/\)
  , type (/\)
  )
import React.Basic.Hooks as React
import Web.HTML (window)
import Web.HTML.HTMLDocument (body)
import Web.HTML.HTMLElement (toElement)
import Web.HTML.Window (document)

main :: Effect Unit
main = do
  body <- body =<< document =<< window
  case body of
    Nothing -> throw "Could not find body."
    Just b -> do
      container <- mkContainer
      render (container unit) (toElement b)

mkContainer :: Component Unit
mkContainer = do
  componentA <- mkComponentA
  componentB <- mkComponentB
  componentC <- mkComponentC
  component "Container" \_ -> React.do
    observedState /\ setObservedState <-
      useState' { a: Nothing, b: Nothing, c: Nothing }
    enabledState <- useState false
    countState <- useState 0
    inputState <- useInput "Hello"
    pure
      $ R.div_
          [ R.div
              { className: "box"
              , children:
                  [ R.h1_ [ R.text "Component A" ]
                  , componentA enabledState
                  ]
              }
          , R.div
              { className: "box"
              , children:
                  [ R.h1_ [ R.text "Component B" ]
                  , componentB countState
                  ]
              }
          , R.div
              { className: "box"
              , children:
                  [ R.h1_ [ R.text "Component C" ]
                  , componentC inputState
                  ]
              }
          , R.p_
              [ R.text "Last observed states:" ]
          , R.ul_
              [ R.li_ [ R.text ("Component A: " <> show observedState.a) ]
              , R.li_ [ R.text ("Component B: " <> show observedState.b) ]
              , R.li_ [ R.text ("Component C: " <> show observedState.c) ]
              ]
          , R.button
              { onClick:
                  handler_ do
                    setObservedState
                      { a: Just (fst enabledState)
                      , b: Just (fst countState)
                      , c: Just (fst inputState)
                      }
              , children: [ R.text "Check states now" ]
              }
          ]

type SetState state
  = (state -> state) -> Effect Unit

mkComponentA :: Component (Boolean /\ SetState Boolean)
mkComponentA =
  component "ComponentA" \(enabled /\ setEnabled) ->
    pure
      $ R.div_
          [ R.p_ [ R.text "Toggle me!" ]
          , R.button
              { onClick: handler_ (setEnabled not)
              , children: [ R.text (if enabled then "On" else "Off") ]
              }
          ]

mkComponentB :: Component (Int /\ SetState Int)
mkComponentB =
  component "ComponentB" \(count /\ setCount) ->
    pure
      $ R.div_
          [ R.p_
              [ R.text "Current value: "
              , R.strong_ [ R.text (show count) ]
              ]
          , R.button
              { onClick: handler_ (setCount (_ + 1))
              , children: [ R.text "Increment" ]
              }
          ]

mkComponentC :: Component (String /\ EventHandler)
mkComponentC =
  component "ComponentC" \(value /\ onChange) ->
    pure
      $ R.label_
          [ R.p_ [ R.text "What do you have to say?" ]
          , R.input { value, onChange }
          ]

useInput :: String -> Hook (UseState String) (String /\ EventHandler)
useInput initialValue = React.do
  state /\ setState <- useState' initialValue
  let
    onChange = handler targetValue \t -> setState (fromMaybe "" t)
  pure (state /\ onChange)
