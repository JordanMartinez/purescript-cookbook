module RoutingPushHalogenClassic.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Class.Console (log)
import Halogen as H
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)
import Routing.PushState (makeInterface, matches)
import RoutingPushHalogenClassic.Example (Query(..))
import RoutingPushHalogenClassic.Example as Example
import RoutingPushHalogenClassic.MyRouting (myRoute)

main :: Effect Unit
main =
  HA.runHalogenAff do
    body <- HA.awaitBody
    halogenIO <- runUI Example.component Nothing body
    void
      $ liftEffect do
          nav <- makeInterface
          nav
            # matches myRoute \oldRoute newRoute -> do
                log $ show oldRoute <> " -> " <> show newRoute
                launchAff_ $ halogenIO.query $ H.tell $ Nav newRoute
