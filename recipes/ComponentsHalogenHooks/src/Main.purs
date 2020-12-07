module ComponentsHalogenHooks.Main where

import Prelude

import Data.Maybe (Maybe(..), maybe)
import Data.Symbol (SProxy(..))
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
    void $ runUI containerComponent unit body

_button :: SProxy "button"
_button = SProxy

containerComponent
  :: forall unusedQuery unusedInput unusedOutput anyMonad
   . H.Component HH.HTML unusedQuery unusedInput unusedOutput anyMonad
containerComponent = Hooks.component \rec _ -> Hooks.do
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
    ]

data ButtonQuery a = IsOn (Boolean -> a)

buttonComponent
  :: forall unusedInput anyMonad
   . H.Component HH.HTML ButtonQuery unusedInput Unit anyMonad
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
          _ <- Hooks.modify enabledIdx not
          Hooks.raise rec.outputToken unit
      ]
      [ HH.text label ]
