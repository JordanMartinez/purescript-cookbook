module TimeHalogenHooks.Main where

import Prelude

import Control.Monad.Rec.Class (forever)
import Data.Enum (fromEnum)
import Data.Interpolate (i)
import Data.Maybe (Maybe(..))
import Data.Time (Time(..))
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Aff (Milliseconds(..), error)
import Effect.Aff as Aff
import Effect.Aff.Class (class MonadAff)
import Effect.Now (nowTime)
import Halogen (liftEffect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.Hooks as Hooks
import Halogen.Query.EventSource (affEventSource)
import Halogen.Query.EventSource as EventSource
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main =
  HA.runHalogenAff do
    body <- HA.awaitBody
    void $ runUI hookComponent Nothing body

hookComponent
  :: forall unusedQuery unusedInput unusedOutput anyMonad
   . MonadAff anyMonad
  => H.Component HH.HTML unusedQuery unusedInput unusedOutput anyMonad
hookComponent = Hooks.component \_ _ -> Hooks.do
  { hour, minute, second } /\ timeIdx <- Hooks.useState
    { hour: 0, minute: 0, second: 0 }

  Hooks.useLifecycleEffect do
    subId <- Hooks.subscribe $ affEventSource \emitter -> do
      fiber <- Aff.forkAff $ forever do
        -- update time
        EventSource.emit emitter do
          nextTime <- getTime
          Hooks.put timeIdx nextTime

        -- wait 1 second and then do it forever
        Aff.delay $ Milliseconds 1000.0

      pure $ EventSource.Finalizer do
        Aff.killFiber (error "Event source finalized") fiber

    pure $ Just do
      Hooks.unsubscribe subId

  Hooks.pure $
    HH.h1_ [ HH.text $ i hour":"minute":"second ]

  where
    getTime = do
      Time h m s _ <- liftEffect $ nowTime
      let
        hour = fromEnum h
        minute = fromEnum m
        second = fromEnum s
      pure { hour, minute, second }
