module DriverRoutingHalogenHooks.Main where

import Prelude

import Control.Coroutine as CR
import Control.Coroutine.Aff (emit)
import Control.Coroutine.Aff as CRA
import Data.Array (snoc)
import Data.Foldable (traverse_)
import Data.Maybe (Maybe(..))
import Data.String.CodeUnits as Str
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Aff (Aff)
import Halogen (liftEffect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.Hooks as Hooks
import Halogen.VDom.Driver (runUI)
import Web.Event.EventTarget (addEventListener, eventListener) as DOM
import Web.HTML (window) as DOM
import Web.HTML.Event.HashChangeEvent as HCE
import Web.HTML.Event.HashChangeEvent.EventTypes as HCET
import Web.HTML.Window as Window

main :: Effect Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody
  io <- runUI routeLogComponent unit body

  -- Connecting the consumer to the producer initializes both, adding the event
  -- listener to the window and feeding queries back to our component as events
  -- are received.
  CR.runProcess (hashChangeProducer CR.$$ hashChangeConsumer io.query)

-- A producer coroutine that emits messages whenever the window emits a
-- `hashchange` event.
hashChangeProducer :: CR.Producer HCE.HashChangeEvent Aff Unit
hashChangeProducer = CRA.produce \emitter -> do
  listener <- DOM.eventListener (traverse_ (emit emitter) <<< HCE.fromEvent)
  liftEffect $
    DOM.window
      >>= Window.toEventTarget
        >>> DOM.addEventListener HCET.hashchange listener false

-- A consumer coroutine that takes the `query` function from our component IO
-- record and sends `ChangeRoute` queries in when it receives inputs from the
-- producer.
hashChangeConsumer
  :: (forall a. Query a -> Aff (Maybe a))
  -> CR.Consumer HCE.HashChangeEvent Aff Unit
hashChangeConsumer query = CR.consumer \event -> do
  let hash = Str.drop 1 $ Str.dropWhile (_ /= '#') $ HCE.newURL event
  void $ query $ H.mkTell $ ChangeRoute hash
  pure Nothing

data Query a = ChangeRoute String a

routeLogComponent
  :: forall unusedInput unusedOutput anyMonad
   . H.Component Query unusedInput unusedOutput anyMonad
routeLogComponent = Hooks.component \rec _ -> Hooks.do
  history /\ historyIdx <- Hooks.useState []
  Hooks.useQuery rec.queryToken case _ of
    ChangeRoute msg next -> do
      Hooks.modify_ historyIdx (\h -> h `snoc` msg)
      pure $ Just next
  Hooks.pure $
    HH.div_
      [ HH.p_ [ HH.text "Change the URL hash or choose an anchor link..." ]
      , HH.ul_
          [ HH.li_ [ HH.a [ HP.href "#link-a" ] [ HH.text "Link A" ] ]
          , HH.li_ [ HH.a [ HP.href "#link-b" ] [ HH.text "Link B" ] ]
          , HH.li_ [ HH.a [ HP.href "#link-c" ] [ HH.text "Link C" ] ]
          ]
      , HH.p_ [ HH.text "...to see it logged below:" ]
      , HH.ol_ $ map (\msg -> HH.li_ [ HH.text msg ]) history
      ]
