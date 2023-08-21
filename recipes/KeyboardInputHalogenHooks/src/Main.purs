module KeyboardInputHalogenHooks.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Data.String as String
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Aff.Class (class MonadAff)
import Effect.Class (liftEffect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.Hooks as Hooks
import Halogen.Query.Event as HE
import Halogen.VDom.Driver (runUI)
import Web.Event.Event as E
import Web.HTML (window) as Web
import Web.HTML.HTMLDocument as HTMLDocument
import Web.HTML.Window (document) as Web
import Web.UIEvent.KeyboardEvent as KE
import Web.UIEvent.KeyboardEvent.EventTypes as KET

main :: Effect Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody
  runUI component unit body

component
  :: forall unusedInput unusedQuery unusedOutput anyMonad
   . MonadAff anyMonad
  => H.Component unusedQuery unusedInput unusedOutput anyMonad
component = Hooks.component \_ _ -> Hooks.do
  chars /\ charsIdx <- Hooks.useState ""
  Hooks.useLifecycleEffect do
    document <- liftEffect $ Web.document =<< Web.window
    let target = HTMLDocument.toEventTarget document
    Hooks.subscribe' \sid -> do
      let
        handleKey _subId keyEvent
          | KE.shiftKey keyEvent = do
              liftEffect $ E.preventDefault (KE.toEvent keyEvent)
              let char = KE.key keyEvent
              when (String.length char == 1) do
                Hooks.modify_ charsIdx \chars' -> chars' <> char
          | KE.key keyEvent == "Enter" = do
              liftEffect $ E.preventDefault (KE.toEvent keyEvent)
              Hooks.put charsIdx ""
              Hooks.unsubscribe sid
          | otherwise = do
              pure unit

      HE.eventListener KET.keyup target \e ->
        handleKey sid <$> KE.fromEvent e

    pure Nothing
  Hooks.pure $
    HH.div_
      [ HH.p_ [ HH.text "Hold down the shift key and type some characters!" ]
      , HH.p_ [ HH.text "Press ENTER or RETURN to clear and remove the event listener." ]
      , HH.p_ [ HH.text chars ]
      ]
