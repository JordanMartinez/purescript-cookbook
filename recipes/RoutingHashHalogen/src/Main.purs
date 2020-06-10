module RoutingHashHalogen.Main where

import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Class.Console (log)
import RoutingHashHalogen.Example (Query(..))
import RoutingHashHalogen.Example as Example
import Halogen as H
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)
import RoutingHashHalogen.MyRouting (myRoute)
import Routing.Hash (matches)

main :: Effect Unit
main =
  HA.runHalogenAff do
    body <- HA.awaitBody
    halogenIO <- runUI Example.component Nothing body
    void $ liftEffect
      $ matches myRoute \oldRoute newRoute -> do
          log $ show oldRoute <> " -> " <> show newRoute
          launchAff_ $ halogenIO.query $ H.tell $ Nav newRoute
