module ButtonsHalogenHooks.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.Hooks as Hooks
import Halogen.VDom.Driver (runUI)
import Data.Tuple.Nested ((/\))

main :: Effect Unit
main =
  HA.runHalogenAff do
    body <- HA.awaitBody
    void $ runUI hookComponent Nothing body

hookComponent
  :: forall unusedQuery unusedInput unusedOutput anyMonad
   . H.Component HH.HTML unusedQuery unusedInput unusedOutput anyMonad
hookComponent = Hooks.component \_ _ -> Hooks.do
  count /\ countIdx <- Hooks.useState 0
  Hooks.pure $
    HH.div_
      [ HH.button
        [ HE.onClick \_ -> Just $ Hooks.modify_ countIdx (_ - 1) ]
        [ HH.text "-" ]
      , HH.div_ [ HH.text $ show count ]
      , HH.button
        [ HE.onClick \_ -> Just $ Hooks.modify_ countIdx (_ + 1) ]
        [ HH.text "+" ]
      ]
