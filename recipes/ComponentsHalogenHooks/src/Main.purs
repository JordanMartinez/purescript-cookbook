module ComponentsHalogenHooks.Main where

import Prelude

import Data.Maybe (Maybe(..), maybe)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.Hooks as Hooks
import Halogen.VDom.Driver (runUI)
import Web.UIEvent.MouseEvent (MouseEvent)

main :: Effect Unit
main =
  HA.runHalogenAff do
    body <- HA.awaitBody
    void $ runUI containerComponent unit body

containerComponent
  :: forall unusedQuery unusedInput unusedOutput anyMonad
   . H.Component HH.HTML unusedQuery unusedInput unusedOutput anyMonad
containerComponent = Hooks.component \rec _ -> Hooks.do
  enabled /\ enabledIdx <- Hooks.useState false
  toggleCount /\ toggleCountIdx <- Hooks.useState 0
  buttonState /\ buttonStateIdx <- Hooks.useState (Nothing :: Maybe Boolean)
  let
    handleClick _ =
      Just do
        Hooks.modify_ toggleCountIdx (_ + 1)
        Hooks.modify_ enabledIdx not
    label = if enabled then "On" else "Off"
  Hooks.pure $
    HH.div_
    [ renderButton {enabled, handleClick}
    , HH.p_
        [ HH.text ("Button has been toggled " <> show toggleCount <> " time(s)") ]
    , HH.p_
        [ HH.text
            $ "Last time I checked, the button was: "
            <> (maybe "(not checked yet)" (if _ then "on" else "off") buttonState)
            <> ". "
        , HH.button
            [ HE.onClick \_ -> Just do
                Hooks.put buttonStateIdx $ Just enabled
            ]
            [ HH.text "Check now" ]
        ]
    ]

renderButton :: forall w i.
  { enabled :: Boolean
  , handleClick :: MouseEvent -> Maybe i
  }
  -> HH.HTML w i
renderButton {enabled, handleClick} =
  let
    label = if enabled then "On" else "Off"
  in
    HH.button
      [ HP.title label
      , HE.onClick handleClick
      ]
      [ HH.text label ]
