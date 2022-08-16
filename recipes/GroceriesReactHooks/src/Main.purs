module GroceriesReactHooks.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception (throw)
import React.Basic.DOM (div_, h1_, li_, text, ul_)
import React.Basic.DOM.Client (createRoot, renderRoot)
import React.Basic.Hooks (Component, component)
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
mkApp = component "Groceries" \_ -> React.do
  pure
    $ div_
        [ h1_ [ text "My Grocery List" ]
        , ul_
            [ li_ [ text "Black Beans" ]
            , li_ [ text "Limes" ]
            , li_ [ text "Greek Yogurt" ]
            , li_ [ text "Cilantro" ]
            , li_ [ text "Honey" ]
            , li_ [ text "Sweet Potatoes" ]
            , li_ [ text "Cumin" ]
            , li_ [ text "Chili Powder" ]
            , li_ [ text "Quinoa" ]
            ]
        ]
