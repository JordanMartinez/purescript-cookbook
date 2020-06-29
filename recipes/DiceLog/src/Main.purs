module DiceLog.Main where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Effect.Random (randomInt)

main :: Effect Unit
main = do
  n <- randomInt 1 6
  log ("You rolled: " <> show n)
