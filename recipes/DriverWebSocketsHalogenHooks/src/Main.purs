module DriverWebSocketsHalogenHooks.Main where

import Prelude

import Control.Coroutine as CR
import Control.Coroutine.Aff (emit)
import Control.Coroutine.Aff as CRA
import Control.Monad.Except (runExcept)
import Data.Array (snoc)
import Data.Either (either)
import Data.Foldable (for_)
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (class MonadEffect, liftEffect)
import Foreign (F, Foreign, unsafeToForeign, readString)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.Hooks as Hooks
import Halogen.VDom.Driver (runUI)
import Web.Event.Event as Event
import Web.Event.EventTarget as EET
import Web.Socket.Event.EventTypes as WSET
import Web.Socket.Event.MessageEvent as ME
import Web.Socket.WebSocket as WS

main :: Effect Unit
main = do
  connection <- WS.create "ws://echo.websocket.org" []
  HA.runHalogenAff do
    body <- HA.awaitBody
    io <- runUI logComponent unit body

    -- The wsSender consumer subscribes to all output messages
    -- from our component
    io.subscribe $ wsSender connection

    -- Connecting the consumer to the producer initializes both,
    -- feeding queries back to our component as messages are received.
    CR.runProcess (wsProducer connection CR.$$ wsConsumer io.query)


-- A producer coroutine that emits messages that arrive from the websocket.
wsProducer :: WS.WebSocket -> CR.Producer String Aff Unit
wsProducer socket = CRA.produce \emitter -> do
  listener <- EET.eventListener \ev -> do
    for_ (ME.fromEvent ev) \msgEvent ->
      for_ (readHelper readString (ME.data_ msgEvent)) \msg ->
        emit emitter msg
  EET.addEventListener
    WSET.onMessage
    listener
    false
    (WS.toEventTarget socket)
  where
    readHelper :: forall a b. (Foreign -> F a) -> b -> Maybe a
    readHelper read =
      either (const Nothing) Just <<< runExcept <<< read <<< unsafeToForeign

-- A consumer coroutine that takes the `query` function from our component IO
-- record and sends `ReceiveMessage` queries in when it receives inputs from the
-- producer.
wsConsumer :: (forall a. Query a -> Aff (Maybe a)) -> CR.Consumer String Aff Unit
wsConsumer query = CR.consumer \msg -> do
  void $ query $ H.tell $ ReceiveMessage msg
  pure Nothing

-- A consumer coroutine that takes output messages from our component IO
-- and sends them using the websocket
wsSender :: WS.WebSocket -> CR.Consumer Message Aff Unit
wsSender socket = CR.consumer \msg -> do
  case msg of
    OutputMessage msgContents ->
      liftEffect $ WS.sendString socket msgContents
  pure Nothing

data Query a = ReceiveMessage String a

data Message = OutputMessage String

logComponent
  :: forall unusedInput anyMonad
   . MonadEffect anyMonad
  => H.Component HH.HTML Query unusedInput Message anyMonad
logComponent = Hooks.component \rec _ -> Hooks.do
  state /\ stateIdx <- Hooks.useState {inputText: "", messages: []}
  Hooks.useQuery rec.queryToken case _ of
    ReceiveMessage msg next -> do
      let incomingMessage = "Received: " <> msg
      Hooks.modify_ stateIdx (\st -> st { messages = st.messages `snoc` incomingMessage })
      pure $ Just next
  Hooks.pure $
    HH.form
    [ HE.onSubmit \ev -> Just do
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
        , HE.onValueInput \val -> Just do
            Hooks.modify_ stateIdx (_ { inputText = val })
        ]
    , HH.button
        [ HP.type_ HP.ButtonSubmit ]
        [ HH.text "Send Message" ]
    ]
