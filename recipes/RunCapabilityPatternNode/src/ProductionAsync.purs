module App.Production.Async where
-- Layer 1 & 2. You can split these in 2 different files if you feel the need to.

import Prelude

import App.Application (GET_USER_NAME, GetUserNameF(..), LOGGER, _getUserName)
import App.Production.Sync as Sync
import App.Types (Name(..))
import Effect.Aff (Aff, Milliseconds(..), delay)
import Effect.Aff.Class (liftAff)
import Node.Encoding (Encoding(..))
import Node.FS.Aff (readTextFile) as Async
import Run (AFF, EFFECT, Run, on, runBaseAff', send)
import Run as Run
import Run.Reader (READER, ask, runReader)
import Type.Row (type (+))

-- | Layer 2 Define our "Production" Monad but using Aff...
type Environment = { asyncEnv :: String }

-- The `GetUserName` dsl can be interpreted without 
-- using `Reader` as an intermediate step (as shown in `ProductionSync`), 
-- but I chose to use Reader here just to show off how you'd go about doing it.
type AppMA r = Run (READER Environment + AFF + EFFECT + r)

-- | Running our monad is just a matter of interpreter composition.
runApp :: Environment -> AppMA (LOGGER + GET_USER_NAME + ()) ~> Aff
runApp env = Sync.runLogger >>> runGetUserName >>> runReader env >>> runBaseAff'

runGetUserName :: forall r. AppMA (GET_USER_NAME + r) ~> AppMA r
runGetUserName = Run.interpret (on _getUserName handleUserName send)
  where
  handleUserName :: GetUserNameF ~> AppMA r
  handleUserName (GetUserName continue) = do
    env <- ask
    liftAff do -- but we can also run computations in Aff
      delay $ Milliseconds 1000.0 -- 1 second
      contents <- Async.readTextFile UTF8 env.asyncEnv
      pure $ continue $ Name contents