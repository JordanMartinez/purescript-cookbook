module GroceriesHalogenHooks.Main where

import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML (HTML, div_, h1_, li_, text, ul_)
import Halogen.Hooks as Hooks
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main =
  HA.runHalogenAff do
    body <- HA.awaitBody
    void $ runUI hookComponent Nothing body

hookComponent ::
  forall unusedQuery unusedInput unusedOutput anyMonad.
  H.Component HTML unusedQuery unusedInput unusedOutput anyMonad
hookComponent =
  Hooks.component \_ _ -> Hooks.do
    Hooks.pure
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
