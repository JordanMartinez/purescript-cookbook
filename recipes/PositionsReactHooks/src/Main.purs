module PositionsReactHooks.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception (throw)
import Effect.Random (randomInt)
import React.Basic.DOM (css)
import React.Basic.DOM as R
import React.Basic.DOM.Client (createRoot, renderRoot)
import React.Basic.Events (handler_)
import React.Basic.Hooks (Component, component, useState', (/\))
import React.Basic.Hooks as React
import Web.DOM.NonElementParentNode (getElementById)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.Window (document)

main :: Effect Unit
main = do
  doc <- document =<< window
  root <- getElementById "root" $ toNonElementParentNode doc
  case root of
    Nothing -> throw "Could not find root."
    Just container -> do
      reactRoot <- createRoot container
      app <- mkApp
      renderRoot reactRoot (app {})

mkApp :: Component {}
mkApp =
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
