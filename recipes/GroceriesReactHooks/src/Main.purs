module GroceriesReactHooks.Main where

import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception (throw)
import React.Basic.DOM (render)
import React.Basic.DOM as R
import React.Basic.Hooks (Component, component)
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
      groceries <- mkGroceries
      render (groceries {}) c

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
