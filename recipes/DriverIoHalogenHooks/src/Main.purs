module DriverIoHalogenHooks.Main where

import Prelude

import Control.Coroutine as CR
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Console (log)
import Halogen (liftEffect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.Hooks as Hooks
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody
  io <- runUI buttonComponent unit body

  io.subscribe $ CR.consumer \(Toggled newState) -> do
    liftEffect $ log $ "Button was internally toggled to: " <> show newState
    pure Nothing

  state0 ← io.query $ H.request IsOn
  liftEffect $ log $ "The button state is currently: " <> show state0

  void $ io.query $ H.tell (SetState true)

  state1 ← io.query $ H.request IsOn
  liftEffect $ log $ "The button state is now: " <> show state1

data ButtonQuery a
  = IsOn (Boolean -> a)
  | SetState Boolean a

data Toggled = Toggled Boolean

buttonComponent
  :: forall unusedInput anyMonad
   . H.Component HH.HTML ButtonQuery unusedInput Toggled anyMonad
buttonComponent = Hooks.component \rec _ -> Hooks.do
  enabled /\ enabledIdx <- Hooks.useState false
  Hooks.useQuery rec.queryToken case _ of
    IsOn reply -> do
      isEnabled <- Hooks.get enabledIdx
      pure $ Just $ reply isEnabled
    SetState newState next -> do
      Hooks.put enabledIdx newState
      pure $ Just next
  let label = if enabled then "On" else "Off"
  Hooks.pure $
    HH.button
      [ HP.title label
      , HE.onClick \_ -> Just do
          newState <- Hooks.modify enabledIdx not
          Hooks.raise rec.outputToken $ Toggled newState
      ]
      [ HH.text label ]
