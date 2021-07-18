module ComponentsMultiTypeHalogenHooks.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Ref as Ref
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
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
containerComponent = Hooks.component \rec _ -> Hooks.do
  parentRenders <- useRenderCount
  state /\ stateIdx <- Hooks.useState { a: Nothing, b: Nothing, c: Nothing }
  let
    _a = Proxy :: Proxy "a"
    _b = Proxy :: Proxy "b"
    _c = Proxy :: Proxy "c"

  Hooks.pure $
    HH.div_
    [ HH.div
        [ HP.class_ (H.ClassName "box")]
        [ HH.h1_ [ HH.text "Component A" ]
        , HH.slot _a unit componentA unit absurd
        ]
    , HH.div
        [ HP.class_ (H.ClassName "box")]
        [ HH.h1_ [ HH.text "Component B" ]
        , HH.slot _b unit componentB unit absurd
        ]
    , HH.div
        [ HP.class_ (H.ClassName "box")]
        [ HH.h1_ [ HH.text "Component C" ]
        , HH.slot _c unit componentC unit absurd
        ]
    , HH.p_
        [ HH.text "Last observed states:"]
    , HH.ul_
        [ HH.li_ [ HH.text ("Component A: " <> show state.a) ]
        , HH.li_ [ HH.text ("Component B: " <> show state.b) ]
        , HH.li_ [ HH.text ("Component C: " <> show state.c) ]
        ]
    , HH.button
        [ HE.onClick \_ -> do
            a <- Hooks.query rec.slotToken _a unit (H.mkRequest IsOn)
            b <- Hooks.query rec.slotToken _b unit (H.mkRequest GetCount)
            c <- Hooks.query rec.slotToken _c unit (H.mkRequest GetValue)
            Hooks.put stateIdx { a, b, c }
        ]
        [ HH.text "Check states now" ]
    , HH.p_
        [ HH.text ("Parent has been rendered " <> show parentRenders <> " time(s)") ]
    ]

data QueryA a = IsOn (Boolean -> a)

componentA
  :: forall unusedInput unusedOutput anyMonad
   . H.Component QueryA unusedInput unusedOutput anyMonad
componentA = Hooks.component \rec _ -> Hooks.do
  enabled /\ enabledIdx <- Hooks.useState false
  Hooks.useQuery rec.queryToken case _ of
    IsOn reply -> do
      isEnabled <- Hooks.get enabledIdx
      pure $ Just $ reply isEnabled
  Hooks.pure $
    HH.div_
    [ HH.p_ [ HH.text "Toggle me!" ]
    , HH.button
        [ HE.onClick \_ -> do
            Hooks.modify_ enabledIdx not ]
        [ HH.text (if enabled then "On" else "Off") ]
    ]

data QueryB a = GetCount (Int -> a)

componentB
  :: forall unusedInput unusedOutput anyMonad
   . H.Component QueryB unusedInput unusedOutput anyMonad
componentB = Hooks.component \rec _ -> Hooks.do
  count /\ countIdx <- Hooks.useState 0
  Hooks.useQuery rec.queryToken case _ of
    GetCount reply -> do
      currentCount <- Hooks.get countIdx
      pure $ Just $ reply currentCount
  Hooks.pure $
    HH.div_
    [ HH.p_
        [ HH.text "Current value: "
        , HH.strong_ [ HH.text (show count) ]
        ]
    , HH.button
        [ HE.onClick \_ -> Hooks.modify_ countIdx (_ + 1) ]
        [ HH.text ("Increment") ]
    ]

data QueryC a = GetValue (String -> a)

componentC
  :: forall unusedInput unusedOutput anyMonad
   . H.Component QueryC unusedInput unusedOutput anyMonad
componentC = Hooks.component \rec _ -> Hooks.do
  state /\ stateIdx <- Hooks.useState "Hello"
  Hooks.useQuery rec.queryToken case _ of
    GetValue reply -> do
      value <- Hooks.get stateIdx
      pure $ Just $ reply value
  Hooks.pure $
    HH.label_
    [ HH.p_ [ HH.text "What do you have to say?" ]
    , HH.input
        [ HP.value state
        , HE.onValueInput (Hooks.put stateIdx)
        ]
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