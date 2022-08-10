module CapabilityPatternNode.Main where

import Prelude

import App.Application (program)
import App.Production.Async (Environment, runApp) as Async
import App.Production.Sync (Environment, runApp) as Sync
import App.Test (Environment, runApp) as Test
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Class.Console (log)
import Test.Assert (assert)

-- | Layer 0 - Running the `program` in three different contexts
main :: Effect Unit
main = launchAff_ do
  -- we can do aff-ish things here with Async/ProductionA version
  _result <- Async.runApp program { asyncEnv: "recipes/CapabilityPatternNode/async.txt" }
  -- ...also able to do synchronous things (within Aff) using liftEffect
  liftEffect $ mainSync { productionEnv: "recipes/CapabilityPatternNode/sync.txt" }
  liftEffect $ mainTest { testEnv: "Test" }
  pure unit

-- Three different "main" functions for three different scenarios
mainSync :: Sync.Environment -> Effect Unit
mainSync env = do
  _result <- Sync.runApp program env
  pure unit

mainTest :: Test.Environment -> Effect Unit
mainTest env = do
  assert $ (Test.runApp program env) == "succeeds"
  log "first test succeeded, now a failing test which will crash"

-- assert $ (Test.runApp program env) == "failing test"

mainAff1 :: Async.Environment -> Effect Unit
mainAff1 env = launchAff_ do
  _result <- Async.runApp program env
  pure unit
