module DriverWebSocketsHalogenHooks.Main where

import Prelude

import Control.Monad.Except (runExcept)
import Data.Array (snoc)
import Data.Either (hush)
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (class MonadEffect, liftEffect)
import Foreign (readString)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.Hooks as Hooks
import Halogen.Query.Event as HQE
import Halogen.Subscription as HS
import Halogen.VDom.Driver (runUI)
import Web.Event.Event as Event
import Web.Socket.Event.EventTypes as WSET
import Web.Socket.Event.MessageEvent as ME
import Web.Socket.WebSocket as WS

-- Adapted from https://github.com/purescript-halogen/purescript-halogen/pull/804
main :: Effect Unit
main = do
  connection <- WS.create "wss://ws.ifelse.io" []
  HA.runHalogenAff do
    body <- HA.awaitBody
    io <- runUI logComponent unit body

    -- Subscribe to all output messages from our component,
    -- forwarding them through the websocket
    let
      forwardToWebsocket = case _ of
        OutputMessage message -> WS.sendString connection message
    _ <- H.liftEffect $ HS.subscribe io.messages forwardToWebsocket

    -- Subscribe to messages from the websocket,
    -- forwarding them to the child component
    let
      websocketEmitter =
        HQE.eventListener WSET.onMessage (WS.toEventTarget connection) wsMessageFromEvent
      forwardToChild =
        launchAff_ <<< void <<< io.query <<< H.mkTell <<< ReceiveMessage
    void $ H.liftEffect $ HS.subscribe websocketEmitter forwardToChild

    pure unit

wsMessageFromEvent :: Event.Event -> Maybe String
wsMessageFromEvent event = do
  wsEvent <- ME.fromEvent event
  let foreignPayload = ME.data_ wsEvent
  foreignPayload # (readString >>> runExcept >>> hush)

data Query a = ReceiveMessage String a

data Message = OutputMessage String

logComponent
  :: forall unusedInput anyMonad
   . MonadEffect anyMonad
  => H.Component Query unusedInput Message anyMonad
logComponent = Hooks.component \rec _ -> Hooks.do
  state /\ stateIdx <- Hooks.useState { inputText: "", messages: [] }
  Hooks.useQuery rec.queryToken case _ of
    ReceiveMessage msg next -> do
      let incomingMessage = "Received: " <> msg
      Hooks.modify_ stateIdx (\st -> st { messages = st.messages `snoc` incomingMessage })
      pure $ Just next
  Hooks.pure $
    HH.form
      [ HE.onSubmit \ev -> do
          liftEffect $ Event.preventDefault ev
          st <- Hooks.get stateIdx
          let outgoingMessage = st.inputText
          Hooks.raise rec.outputToken $ OutputMessage outgoingMessage
          Hooks.modify_ stateIdx \st' -> st'
            { messages = st'.messages `snoc` ("Sending: " <> outgoingMessage)
            , inputText = ""
            }
      ]
      [ HH.ol_ $ map (\msg -> HH.li_ [ HH.text msg ]) state.messages
      , HH.input
          [ HP.type_ HP.InputText
          , HP.value state.inputText
          , HE.onValueInput \val -> do
              Hooks.modify_ stateIdx (_ { inputText = val })
          ]
      , HH.button
          [ HP.type_ HP.ButtonSubmit ]
          [ HH.text "Send Message" ]
      ]
