module App.Production.Sync where
-- Layers One and Two have to be in same file due to orphan instance restriction

import Prelude

import App.Types (Name(..))
import App.Application (class Logger, class GetUserName)
import Control.Monad.Reader (class MonadAsk, ReaderT, ask, asks, runReaderT)
import Effect (Effect)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Class.Console (log) as Console
import Node.Encoding (Encoding(..))
import Node.FS.Sync (readTextFile) as Sync
import Type.Equality (class TypeEquals, from)

-- | Layer 2 Define our "Production" Monad...
type Environment = { productionEnv :: String }
newtype AppM a = AppM (ReaderT Environment Effect a)

-- | ...and the means to run computations in it
runApp :: forall a. AppM a -> Environment -> Effect a
runApp (AppM reader_T) env = runReaderT reader_T env


-- | Layer 1 Provide instances for all capabilities needed
-- | Many of the instances are provided by deriving from the 
-- | underlying ReaderT...
derive newtype instance functorAppM     :: Functor AppM
derive newtype instance applyAppM       :: Apply AppM
derive newtype instance applicativeAppM :: Applicative AppM
derive newtype instance bindAppM        :: Bind AppM
derive newtype instance monadAppM       :: Monad AppM
derive newtype instance monadEffectAppM :: MonadEffect AppM

-- | Reader instance not quite as simple a derivation as "derive newtype",
-- | as it needs TypeEquals for the env
instance monadAskAppM :: TypeEquals e Environment => MonadAsk e AppM where
  ask = AppM $ asks from

-- | implementing Logger here just to the console, but in real world you'd use
-- | the available Env to determine log levels, output destination, DB handles etc
instance loggerAppM :: Logger AppM where
  log = liftEffect <<< Console.log

-- | a version of getUserName that reads the name from a file 
-- | given in the Environment
instance getUserNameAppM :: GetUserName AppM where
  getUserName = do
    env <- ask
    contents <- liftEffect $ Sync.readTextFile UTF8 env.productionEnv
    pure $ Name contents
