module GroceriesReactHooks.Main where

import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception (throw)
import React.Basic.DOM (div_, h1_, li_, render, text, ul_)
import React.Basic.Hooks (Component, component)
import Web.HTML (window)
import Web.HTML.HTMLDocument (body)
import Web.HTML.HTMLElement (toElement)
import Web.HTML.Window (document)

main :: Effect Unit
main = do
  body <- body =<< document =<< window
  case body of
    Nothing -> throw "Root element not found."
    Just b -> do
      groceries <- mkGroceries
      render (groceries {}) (toElement b)

mkGroceries :: Component {}
mkGroceries = do
  component "Groceries" \_ -> React.do
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
