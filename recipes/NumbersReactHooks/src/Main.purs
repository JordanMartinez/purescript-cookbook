module NumbersReactHooks.Main where

import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception (throw)
import Effect.Random (randomInt)
import React.Basic.DOM (render)
import React.Basic.DOM as R
import React.Basic.Events (handler_)
import React.Basic.Hooks (Component, component, useState', (/\))
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
      numbers <- mkNumbers
      render (numbers {}) (toElement b)

mkNumbers :: Component {}
mkNumbers = do
  component "Numbers" \_ -> React.do
    roll /\ setRoll <- useState' 1
    let
      onClick =
        handler_ do
          n <- randomInt 1 6
          setRoll n
    pure
      $ R.div_
          [ R.h1_ [ R.text (show roll) ]
          , R.button { onClick, children: [ R.text "Roll" ] }
          ]
