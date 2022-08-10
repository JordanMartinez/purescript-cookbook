module ButtonsReactHooks.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception (throw)
import React.Basic.DOM as R
import React.Basic.DOM.Client (createRoot, renderRoot)
import React.Basic.Events (handler_)
import React.Basic.Hooks (Component, component, useState, (/\))
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
  component "Buttons" \_ -> React.do
    count /\ setCount <- useState 0
    let handleClick = handler_ <<< setCount
    pure $ R.div_
      [ R.button { onClick: handleClick (_ - 1), children: [ R.text "-" ] }
      , R.div_ [ R.text (show count) ]
      , R.button { onClick: handleClick (_ + 1), children: [ R.text "+" ] }
      ]
