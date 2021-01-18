module ComponentsHalogenHooks.Main where

import Prelude hiding (top)

import Data.Maybe (Maybe(..), maybe)
import Data.Symbol (SProxy(..))
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Class (class MonadEffect)
import Effect.Ref as Ref
import Halogen (liftEffect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.Hooks (Hooked, UseEffect, UseRef)
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
containerComponent = Hooks.component \rec _ -> Hooks.do
  parentRenders <- useRenderCount
  toggleCount /\ toggleCountIdx <- Hooks.useState 0
  buttonState /\ buttonStateIdx <- Hooks.useState (Nothing :: Maybe Boolean)
  Hooks.pure $
    HH.div_
    [ HH.slot _button unit buttonComponent unit \_ -> Just do
        Hooks.modify_ toggleCountIdx (_ + 1)
    , HH.p_
        [ HH.text ("Button has been toggled " <> show toggleCount <> " time(s)") ]
    , HH.p_
        [ HH.text
            $ "Last time I checked, the button was: "
            <> (maybe "(not checked yet)" (if _ then "on" else "off") buttonState)
            <> ". "
        , HH.button
            [ HE.onClick \_ -> Just do
                mbBtnState <- Hooks.query rec.slotToken _button unit $ H.request IsOn
                Hooks.put buttonStateIdx mbBtnState
            ]
            [ HH.text "Check now" ]
        ]
    , HH.p_
        [ HH.text ("Parent has been rendered " <> show parentRenders <> " time(s)") ]
    ]

data ButtonMessage = Toggled Boolean
data ButtonQuery a = IsOn (Boolean -> a)

buttonComponent
  :: forall unusedInput anyMonad
   . H.Component HH.HTML ButtonQuery unusedInput ButtonMessage anyMonad
buttonComponent = Hooks.component \rec _ -> Hooks.do
  enabled /\ enabledIdx <- Hooks.useState false
  Hooks.useQuery rec.queryToken case _ of
    IsOn reply -> do
      isEnabled <- Hooks.get enabledIdx
      pure $ Just $ reply isEnabled
  let label = if enabled then "On" else "Off"
  Hooks.pure $
    HH.button
      [ HP.title label
      , HE.onClick \_ -> Just do
          newState <- Hooks.modify enabledIdx not
          Hooks.raise rec.outputToken $ Toggled newState
      ]
      [ HH.text label ]

useRenderCount
  :: forall m a
   . MonadEffect m
  => Hooked m a (UseEffect (UseRef Int a)) Int
useRenderCount = Hooks.do
  renders /\ rendersRef <- Hooks.useRef 1
  Hooks.captures {} Hooks.useTickEffect do
    liftEffect (Ref.modify_ (_ + 1) rendersRef)
    mempty
  Hooks.pure renders