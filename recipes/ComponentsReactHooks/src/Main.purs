module ComponentsReactHooks.Main where

import Prelude
import Data.Maybe (Maybe(..), maybe)
import Effect (Effect)
import Effect.Exception (throw)
import React.Basic.DOM (render)
import React.Basic.DOM as R
import React.Basic.Events (EventHandler, handler_)
import React.Basic.Hooks (Component, component, useState, (/\))
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
  button <- mkButton
  component "Container" \_ -> React.do
    count /\ setCount <- useState 0
    enabled /\ setEnabled <- useState false
    buttonState /\ setButtonState <- useState Nothing
    let
      handleClick =
        handler_ do
          setCount (_ + 1)
          setEnabled not
    pure
      $ R.div_
          [ button { enabled, handleClick }
          , R.p_
              [ R.text ("Button has been toggled " <> show count <> " time(s)") ]
          , R.p_
              [ R.text
                  $ "Last time I checked, the button was: "
                  <> (maybe "(not checked yet)" (if _ then "on" else "off") buttonState)
                  <> ". "
              , R.button
                  { onClick: handler_ (setButtonState \_ -> Just enabled)
                  , children: [ R.text "Check now" ]
                  }
              ]
          ]

mkButton :: Component { enabled :: Boolean, handleClick :: EventHandler }
mkButton =
  component "Button" \props -> React.do
    let
      label = if props.enabled then "On" else "Off"
    pure
      $ R.button
          { title: label
          , onClick: props.handleClick
          , children: [ R.text label ]
          }
