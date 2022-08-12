module RoutingHashLog.Main where

import Prelude

import Effect (Effect)
import RoutingHashLog.MyRouting (logRoute)

main :: Effect (Effect Unit)
main = logRoute
