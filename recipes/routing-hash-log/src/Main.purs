module Main where

import Prelude
import Effect (Effect)
import MyRouting (logRoute)

main :: Effect (Effect Unit)
main = logRoute
