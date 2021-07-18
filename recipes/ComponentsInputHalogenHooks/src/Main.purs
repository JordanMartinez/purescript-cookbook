module ComponentsInputHalogenHooks.Main where

import Prelude hiding (top)

import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Ref as Ref
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.Hooks (type (<>), Hook, UseEffect, UseRef)
import Halogen.Hooks as Hooks
import Halogen.VDom.Driver (runUI)
import Type.Proxy (Proxy(..))

main :: Effect Unit
main =
  HA.runHalogenAff do
    body <- HA.awaitBody
    void $ runUI containerComponent unit body

_button :: Proxy "button"
_button = Proxy

containerComponent
  :: forall unusedQuery unusedInput unusedOutput anyMonad
   . MonadEffect anyMonad
  => H.Component unusedQuery unusedInput unusedOutput anyMonad
containerComponent = Hooks.component \_ _ -> Hooks.do
  parentRenders <- useRenderCount
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
        [ HE.onClick \_ -> Hooks.modify_ stateIdx (_ + 1) ]
        [ HH.text "+1"]
    , HH.button
        [ HE.onClick \_ -> Hooks.modify_ stateIdx (_ - 1) ]
        [ HH.text "-1"]
    , HH.p_
        [ HH.text ("Parent has been rendered " <> show parentRenders <> " time(s)") ]
    ]

_display = Proxy :: Proxy "display"

displayComponent
  :: forall unusedQuery unusedOutput anyMonad
   . MonadEffect anyMonad
  => H.Component unusedQuery Int unusedOutput anyMonad
displayComponent = Hooks.component \_ input -> Hooks.do
  Hooks.pure $
    HH.div_
    [ HH.text "My input value is:"
    , HH.strong_ [ HH.text (show input) ]
    ]

useRenderCount
  :: forall m a
   . MonadEffect m
  => Hook m (UseRef Int <> UseEffect <> a) Int
useRenderCount = Hooks.do
  renders /\ rendersRef <- Hooks.useRef 1
  Hooks.captures {} Hooks.useTickEffect do
    liftEffect (Ref.modify_ (_ + 1) rendersRef)
    mempty
  Hooks.pure renders