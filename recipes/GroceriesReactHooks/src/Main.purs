module GroceriesReactHooks.Main where

import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception (throw)
import React.Basic.DOM (render)
import React.Basic.DOM as R
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
      $ R.div_
          [ R.h1_ [ R.text "My Grocery List" ]
          , R.ul_
              [ R.li_ [ R.text "Black Beans" ]
              , R.li_ [ R.text "Limes" ]
              , R.li_ [ R.text "Greek Yogurt" ]
              , R.li_ [ R.text "Cilantro" ]
              , R.li_ [ R.text "Honey" ]
              , R.li_ [ R.text "Sweet Potatoes" ]
              , R.li_ [ R.text "Cumin" ]
              , R.li_ [ R.text "Chili Powder" ]
              , R.li_ [ R.text "Quinoa" ]
              ]
          ]
