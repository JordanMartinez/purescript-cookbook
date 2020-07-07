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
import Web.DOM.NonElementParentNode (getElementById)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.Window (document)

main :: Effect Unit
main = do
  container <- getElementById "root" =<< map toNonElementParentNode (document =<< window)
  case container of
    Nothing -> throw "Root element not found."
    Just c -> do
      numbers <- mkNumbers
      render (numbers {}) c

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
