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
      positions <- mkPositions
      render (positions {}) (toElement b)

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
