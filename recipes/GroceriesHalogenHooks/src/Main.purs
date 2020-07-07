module GroceriesHalogenHooks.Main where

import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Halogen as H
import Halogen.HTML as HH
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)
import Halogen.Hooks as Hooks

main :: Effect Unit
main =
  HA.runHalogenAff do
    body <- HA.awaitBody
    void $ runUI hookComponent Nothing body

hookComponent
  :: forall unusedQuery unusedInput unusedOutput anyMonad
   . H.Component HH.HTML unusedQuery unusedInput unusedOutput anyMonad
hookComponent = Hooks.component \_ _ -> Hooks.do
  Hooks.pure $
    HH.div_
      [ HH.h1_ [ HH.text "My Grocery List" ]
      , HH.ul_
        [ HH.li_ [ HH.text "Black Beans" ]
        , HH.li_ [ HH.text "Limes" ]
        , HH.li_ [ HH.text "Greek Yogurt" ]
        , HH.li_ [ HH.text "Cilantro" ]
        , HH.li_ [ HH.text "Honey" ]
        , HH.li_ [ HH.text "Sweet Potatoes" ]
        , HH.li_ [ HH.text "Cumin" ]
        , HH.li_ [ HH.text "Chili Powder" ]
        , HH.li_ [ HH.text "Quinoa" ]
        ]
      ]
