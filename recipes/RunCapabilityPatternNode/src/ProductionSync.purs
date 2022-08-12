module App.Production.Sync where

-- Layer 1 & 2. You can split these in 2 different files if you feel the need to.

import Prelude

import App.Application (GET_USER_NAME, GetUserNameF(..), LOGGER, LoggerF(..), _getUserName, _logger)
import App.Types (Name(..))
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Class.Console (log)
import Node.Encoding (Encoding(..))
import Node.FS.Sync (readTextFile) as Sync
import Run (EFFECT, Run, on, runBaseEffect, send)
import Run as Run
import Type.Row (type (+))

-- | Layer 2 Define our "Production" Monad...
type Environment = { productionEnv :: String }
type AppM r = Run (EFFECT + r)

-- | Running our monad is just a matter of interpreter composition.
runApp :: Environment -> AppM (LOGGER + GET_USER_NAME + ()) ~> Effect
runApp env = runLogger >>> runGetUserName env >>> runBaseEffect

runLogger :: forall r. AppM (LOGGER + r) ~> AppM r
runLogger = Run.interpret (on _logger handleLogger send)
  where
  handleLogger :: LoggerF ~> AppM r
  handleLogger (Log message a) = log message $> a

runGetUserName :: forall r. Environment -> AppM (GET_USER_NAME + r) ~> AppM r
runGetUserName env = Run.interpret (on _getUserName handleUserName send)
  where
  handleUserName :: GetUserNameF ~> AppM r
  handleUserName (GetUserName continue) = do
    contents <- liftEffect $ Sync.readTextFile UTF8 env.productionEnv
    pure $ continue $ Name contents