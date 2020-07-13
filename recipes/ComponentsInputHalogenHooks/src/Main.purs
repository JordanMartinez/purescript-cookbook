module ComponentsInputHalogenHooks.Main where

import Prelude hiding (top)

import Data.Maybe (Maybe, maybe)
import Data.Symbol (SProxy(..))
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Class (class MonadEffect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.Hooks as Hooks
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main =
  HA.runHalogenAff do
    body <- HA.awaitBody
    void $ runUI containerComponent unit body

_button :: SProxy "button"
_button = SProxy

containerComponent
  :: forall unusedQuery unusedInput unusedOutput anyMonad
   . MonadEffect anyMonad
  => H.Component HH.HTML unusedQuery unusedInput unusedOutput anyMonad
containerComponent = Hooks.component \_ _ -> Hooks.do
  state /\ stateIdx <- Hooks.useState 0
  Hooks.pure $
    HH.div_
    [ HH.ul_
        [ HH.slot _display 1 displayComponent state absurd
        , HH.slot _display 2 displayComponent (state * 2) absurd
        , HH.slot _display 3 displayComponent (state * 3) absurd
        , HH.slot _display 4 displayComponent (state * 10) absurd
        , HH.slot _display 5 displayComponent (state * state) absurd
        ]
    , HH.button
        [ HE.onClick \_ -> Just $ Hooks.modify_ stateIdx (_ + 1) ]
        [ HH.text "+1"]
    , HH.button
        [ HE.onClick \_ -> Just $ Hooks.modify_ stateIdx (_ - 1) ]
        [ HH.text "-1"]
    ]

_display = SProxy :: SProxy "display"

displayComponent
  :: forall unusedQuery unusedOutput anyMonad
   . MonadEffect anyMonad
  => H.Component HH.HTML unusedQuery Int unusedOutput anyMonad
displayComponent = Hooks.component \_ input -> Hooks.do
  Hooks.pure $
    HH.div_
    [ HH.text "My input value is:"
    , HH.strong_ [ HH.text (show input) ]
    ]
