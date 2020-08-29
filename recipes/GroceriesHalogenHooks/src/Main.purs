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

{-
NOTE: Most Halogen codebases will reference HTML tags via an `HH` prefix
(i.e. `HH.div` rather than `div`). The `HH` is from `import Halogen.HTML as HH`.
Most developers _choose_ to use the `HH` prefix, but it is not a requirement
of the language, nor the library.

To decrease verbosity and better compare this code to Elm's code,
the above syntax does not use the `HH` prefix. 
-}
