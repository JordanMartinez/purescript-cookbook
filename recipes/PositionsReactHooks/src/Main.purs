module PositionsReactHooks.Main where

import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception (throw)
import Effect.Random (randomInt)
import React.Basic.DOM (css, render)
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
      positions <- mkPositions
      render (positions {}) c

mkPositions :: Component {}
mkPositions = do
  component "Positions" \_ -> React.do
    { x, y } /\ setPosition <- useState' { x: 100, y: 100 }
    let
      onClick =
        handler_ do
          newX <- randomInt 50 350
          newY <- randomInt 50 350
          setPosition { x: newX, y: newY }
    pure
      $ R.button
          { onClick
          , style:
              css
                { position: "absolute"
                , top: show x <> "px"
                , left: show y <> "px"
                }
          , children: [ R.text "Click me!" ]
          }
