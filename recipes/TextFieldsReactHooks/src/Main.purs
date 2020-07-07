module TextFieldsReactHooks.Main where

import Prelude
import Data.Array as Array
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String (fromCodePointArray, toCodePointArray)
import Effect (Effect)
import Effect.Exception (throw)
import React.Basic.DOM (render)
import React.Basic.DOM as R
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
  container <- getElementById "root" =<< map toNonElementParentNode (document =<< window)
  case container of
    Nothing -> throw "Root element not found."
    Just c -> do
      textField <- mkTextField
      render (textField {}) c

mkTextField :: Component {}
mkTextField = do
  component "TextField" \_ -> React.do
    content /\ setContent <- useState ""
    let
      onChange = handler targetValue (setContent <<< const <<< fromMaybe "")
    pure
      $ R.div_
          [ R.input { placeholder: "Text to reverse", value: content, onChange }
          , R.div_ [ R.text (reverse content) ]
          ]

reverse :: String -> String
reverse = fromCodePointArray <<< Array.reverse <<< toCodePointArray
