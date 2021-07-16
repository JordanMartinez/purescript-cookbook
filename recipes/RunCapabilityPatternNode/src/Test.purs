module App.Test where
-- Layer 1 & 2. You can split these in 2 different files if you feel the need to.

import Prelude

import App.Application (GetUserNameF(..), LOGGER, LoggerF(..), GET_USER_NAME, _getUserName, _logger)
import App.Types (Name(..))
import Run (Run, extract, on, send)
import Run as Run
import Type.Row (type (+))

-- | Layer 2 Define our "Test" Monad...

type Environment = { testEnv :: String }
type TestM r = Run r

-- | Running our monad is just a matter of interpreter composition.
runApp :: forall a. TestM (LOGGER + GET_USER_NAME + ()) a -> a
runApp = runLogger >>> runGetUserName  >>> extract

runLogger :: forall r. TestM (LOGGER + r) ~> TestM r
runLogger = Run.interpret (on _logger handleLogger send)
  where
  handleLogger :: LoggerF ~> TestM r 
  handleLogger (Log _ a) = pure a

runGetUserName :: forall r.  TestM (GET_USER_NAME + r) ~> TestM r
runGetUserName = Run.interpret (on _getUserName handleUserName send)
  where
  handleUserName :: GetUserNameF ~> TestM r
  handleUserName (GetUserName continue) = pure $ continue $ Name "succeeds"