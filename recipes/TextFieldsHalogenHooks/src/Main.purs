module TextFieldsHalogenHooks.Main where

import Prelude

import Data.Array as Array
import Data.Maybe (Maybe(..))
import Data.String (fromCodePointArray, toCodePointArray)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.Hooks as Hooks
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main =
  HA.runHalogenAff do
    body <- HA.awaitBody
    void $ runUI hookComponent Nothing body

hookComponent
  :: forall unusedQuery unusedInput unusedOutput anyMonad
   . H.Component HH.HTML unusedQuery unusedInput unusedOutput anyMonad
hookComponent = Hooks.component \_ _ -> Hooks.do
  state /\ stateIdx <- Hooks.useState ""
  Hooks.pure $
    HH.div_
      [ HH.input
        [ HP.placeholder "Text to reverse"
        , HP.value state
        , HE.onValueInput \newValue -> Just $ Hooks.put stateIdx newValue
        ]
      , HH.div_ [ HH.text $ reverse state ]
      ]

reverse :: String -> String
reverse = fromCodePointArray <<< Array.reverse <<< toCodePointArray
