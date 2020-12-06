module ComponentsInputReactHooks.Main where

import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception (throw)
import React.Basic.DOM (render)
import React.Basic.DOM as R
import React.Basic.Events (handler_)
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
  display <- mkDisplay
  component "Container" \_ -> React.do
    state /\ setState <- useState 0
    pure
      $ R.div_
          [ R.ul_
              [ display state
              , display (state * 2)
              , display (state * 3)
              , display (state * 10)
              , display (state * state)
              ]
          , R.button
              { onClick: handler_ (setState (_ + 1))
              , children: [ R.text "+1" ]
              }
          , R.button
              { onClick: handler_ (setState (_ - 1))
              , children: [ R.text "-1" ]
              }
          ]

mkDisplay :: Component Int
mkDisplay =
  component "Display" \n ->
    pure
      $ R.div_
          [ R.text "My input value is: "
          , R.strong_ [ R.text (show n) ]
          ]
