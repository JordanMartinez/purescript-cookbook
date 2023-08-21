module TimeHalogenHooks.Main where

import Prelude

import Control.Monad.Rec.Class (forever)
import Data.Int (floor)
import Data.Interpolate (i)
import Data.JSDate as JSDate
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Aff (Milliseconds(..), error)
import Effect.Aff as Aff
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.Hooks as Hooks
import Halogen.Subscription as HS
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main =
  HA.runHalogenAff do
    body <- HA.awaitBody
    void $ runUI hookComponent unit body

hookComponent
  :: forall unusedQuery unusedInput unusedOutput anyMonad
   . MonadAff anyMonad
  => H.Component unusedQuery unusedInput unusedOutput anyMonad
hookComponent = Hooks.component \_ _ -> Hooks.do
  { hour, minute, second } /\ timeIdx <- Hooks.useState
    { hour: 0, minute: 0, second: 0 }

  Hooks.useLifecycleEffect do
    { emitter, listener } <- H.liftEffect HS.create
    subId <- Hooks.subscribe emitter
    fiber <- H.liftAff $ Aff.forkAff $ forever do
      -- update time
      H.liftEffect $ HS.notify listener do
        nextTime <- getTime
        Hooks.put timeIdx nextTime

      -- wait 1 second and then do it forever
      Aff.delay $ Milliseconds 1000.0

    pure $ Just do
      H.liftAff $ Aff.killFiber (error "Event source finalized") fiber
      Hooks.unsubscribe subId

  Hooks.pure $
    HH.h1_ [ HH.text $ i hour ":" minute ":" second ]

  where
  getTime = H.liftEffect do
    now <- JSDate.now
    hour <- floor <$> JSDate.getHours now
    minute <- floor <$> JSDate.getMinutes now
    second <- floor <$> JSDate.getSeconds now
    pure { hour, minute, second }
