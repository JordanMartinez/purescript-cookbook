module TextFieldsReactHooks.Main where

import Prelude

import Data.Array as Array
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String (fromCodePointArray, toCodePointArray)
import Effect (Effect)
import Effect.Exception (throw)
import React.Basic.DOM as R
import React.Basic.DOM.Client (createRoot, renderRoot)
import React.Basic.DOM.Events (targetValue)
import React.Basic.Events (handler)
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
  component "TextField" \_ -> React.do
    content /\ setContent <- useState ""
    let onChange = handler targetValue (setContent <<< const <<< fromMaybe "")
    pure $ R.div_
      [ R.input { placeholder: "Text to reverse", value: content, onChange }
      , R.div_ [ R.text (reverse content) ]
      ]

reverse :: String -> String
reverse = fromCodePointArray <<< Array.reverse <<< toCodePointArray
