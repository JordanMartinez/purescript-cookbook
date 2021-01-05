module App.ProductionExcV where

import Prelude

import App.Application (class GetUserName, class Logger)
import App.Types (Name(..))
import Control.Monad.Error.Class (class MonadThrow, throwError)
import Control.Monad.Except (runExceptT)
import Control.Monad.Except.Checked (ExceptV, handleError, safe)
import Control.Monad.Reader (class MonadAsk, ReaderT, ask, asks, runReaderT)
import Data.Either (Either(..))
import Data.Variant (class VariantShows, Variant)
import Data.Variant.Internal (class VariantTags, RProxy(..))
import Effect.Aff (Aff, error)
import Effect.Aff.Class (class MonadAff)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Class.Console as Console
import Node.Path (FilePath)
import Prim.RowList (class RowToList)
import Service.FS (class MonadFs, FsError)
import Service.FS (write) as FS
import Service.HTTP (class MonadHttp, HttpError)
import Service.HTTP (get) as HTTP
import Type.Data.Row (RProxy)
import Type.Equality (class TypeEquals, from)
import Type.Row (type (+))

    

-- the type that we expect to be in the ReaderT as our environment
type Environment = { url :: String }

-- | Aff wrapped in ExceptV wrapped in ReaderT
newtype AppExcV var a = AppExcV (ReaderT Environment (ExceptV var Aff) a)

-- newtype AppMA a = AppMA (ReaderT Environment Aff a)

-- runApp :: forall a. AppMA a -> Environment -> Aff a
-- runApp (AppMA reader_T) env = runReaderT reader_T env

-- | ...and the means to run computations in it
runApp :: forall a. AppExcV () a -> Environment -> Aff a
runApp rave env = runAppExcV (RProxy :: _ ()) env rave
  where
    runAppExcV :: forall var rl.
      RowToList var rl =>
      VariantTags rl =>
      VariantShows rl =>
      RProxy var ->
      Environment ->
      AppExcV var a ->
      Aff a
    runAppExcV _ env (AppExcV rave) = do
      ran <- runExceptT $ runReaderT rave env
      case ran of
        Right res -> pure res
        Left l -> throwError $ error $ show l

-- | Layer 1 all the instances for the AppExcV monad
derive newtype instance raveMonadAff    :: MonadAff (AppExcV var)
derive newtype instance raveMonadEffect :: MonadEffect (AppExcV var)
derive newtype instance raveMonad       :: Monad (AppExcV var)
derive newtype instance raveApplicative :: Applicative (AppExcV var)
derive newtype instance raveApply       :: Apply (AppExcV var)
derive newtype instance raveFunctor     :: Functor (AppExcV var)
derive newtype instance raveBind        :: Bind (AppExcV var)
derive newtype instance raveMonadError  :: MonadThrow (Variant var) (AppExcV var)

-- | Capability instances
instance raveMonadHttp :: MonadHttp (AppExcV var)

instance raveMonadFS   :: MonadFs (AppExcV var)

instance raveMonadAsk :: TypeEquals e1 Environment => MonadAsk e1 (AppExcV v) where
  ask = AppExcV $ asks from

instance loggerAppExcV :: Logger (AppExcV var) where
  log msg = liftEffect $ Console.log msg

instance getUserNameAppExcV :: GetUserName (AppExcV var) where
  getUserName = do
    env <- ask

    foo <- safe $ (getPureScript env.url) # handleError (errorHandlersWithDefault unit)
  
    pure $ Name "AppExcV"

-- | an example of a function which combines the underlying services and thus
-- | has the possibility of raising errors from either one

getPureScript :: forall m r
  .  Monad m
  => MonadHttp m
  => MonadFs m
  => String -> ExceptV  (HttpError + FsError + r) m Unit
getPureScript url = do
  HTTP.get url >>= FS.write "~/purescript.html"


-- | this function is used to declutter the implementation of `getUserName`
-- | Provides exception handling functions for the _combined_ exceptions of HTTP and FS services
-- | such that the `ExceptV` can be entirely unwrapped, using `safe` from `checked-exceptions`
errorHandlersWithDefault :: forall m r a.
  MonadEffect m =>
  a -> 
  { fsFileNotFound     :: FilePath -> m a
  , fsPermissionDenied :: Unit -> m a
  , httpNotFound       :: Unit -> m a
  , httpOther          :: { body :: String, status :: Int} -> m a
  , httpServerError    :: String -> m a
  }
errorHandlersWithDefault defaultValue = {
    httpServerError:    \error -> do
      Console.log $ "Server error:" <> error
      pure defaultValue
  , httpNotFound:       \error -> do
      Console.log "Not found"
      pure defaultValue
  , httpOther:          \error -> do
      Console.log $ "Other: { status: " <> show error.status <> " , body: " <> error.body <> "}"
      pure defaultValue
  , fsFileNotFound:     \error -> do
      Console.log $ "File Not Found" <> error
      pure defaultValue
  , fsPermissionDenied: \error -> do
      Console.log "Permission Denied"
      pure defaultValue
}
