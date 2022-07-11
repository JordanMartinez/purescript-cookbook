module RunCapabilityPatternNode.Main where

import Prelude

import App.Application (program)
import App.Production.Async (Environment,  runApp) as Async
import App.Production.Sync (Environment,  runApp) as Sync
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
  _ <- Async.runApp { asyncEnv: "recipes/RunCapabilityPatternNode/async.txt" } program
  -- ...also able to do synchronous things (within Aff) using liftEffect
  liftEffect $ mainSync { productionEnv: "recipes/RunCapabilityPatternNode/sync.txt" }
  liftEffect $ mainTest { testEnv: "Test" }

-- Three different "main" functions for three different scenarios
mainSync :: Sync.Environment -> Effect Unit
mainSync env = void $ Sync.runApp env program

mainTest :: Test.Environment -> Effect Unit
mainTest _ = do
  assert $ (Test.runApp program) == "succeeds"
  log "first test succeeded, now a failing test which will crash"
  -- assert $ (Test.runApp program) == "failing test"

mainAff1 :: Async.Environment -> Effect Unit
mainAff1 env = launchAff_ $ void $ Async.runApp env program
