module App.Production.Async where
-- Layers One and Two have to be in same file due to orphan instance restriction

import Prelude

import App.Types (Name(..))
import App.Application (class Logger, class GetUserName)
import Control.Monad.Reader (class MonadAsk, ReaderT, ask, asks, runReaderT)
import Effect.Aff (Aff, Milliseconds(..), delay)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Class.Console (log) as Console
import Node.Encoding (Encoding(..))
import Node.FS.Aff (readTextFile) as Async
import Type.Equality (class TypeEquals, from)

-- | Layer 2 Define our "Production" Monad but using Aff...
type Environment = { asyncEnv :: String }
newtype AppMA a = AppMA (ReaderT Environment Aff a)

-- | ...and the means to run computations in it
runApp :: forall a. AppMA a -> Environment -> Aff a
runApp (AppMA reader_T) env = runReaderT reader_T env

-- | Layer 1 Production in Aff
derive newtype instance functorAppMA     :: Functor AppMA
derive newtype instance applyAppMA       :: Apply AppMA
derive newtype instance applicativeAppMA :: Applicative AppMA
derive newtype instance bindAppMA        :: Bind AppMA
derive newtype instance monadAppMA       :: Monad AppMA
derive newtype instance monadEffectAppMA :: MonadEffect AppMA
derive newtype instance monadAffAppMA    :: MonadAff AppMA

-- | Reader instance not quite as simple a derivation as "derive newtype",
-- | as it needs TypeEquals for the env
instance monadAskAppMA :: TypeEquals e Environment => MonadAsk e AppMA where
  ask = AppMA $ asks from

-- | implementing Logger here just to the console, but in real world you'd use
-- | the available Env to determine log levels, output destination, DB handles etc
-- | because this version runs in Aff you can do Aff-ish things here (not shown)
instance loggerAppMA :: Logger AppMA where
  log = liftEffect <<< Console.log

-- | a version of getUserName that reads the name from a file 
-- | given in the Environment
instance getUserNameAppMA :: GetUserName AppMA where
  getUserName = do
    env <- ask -- we still have access to underlying ReaderT
    liftAff do -- but we can also run computations in Aff
      delay $ Milliseconds 1000.0 -- 1 second
      contents <- Async.readTextFile UTF8 env.asyncEnv
      pure $ Name $ contents
