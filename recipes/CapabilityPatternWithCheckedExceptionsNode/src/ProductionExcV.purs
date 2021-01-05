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
newtype AppExcVM var a = AppExcVM (ReaderT Environment (ExceptV var Aff) a)

-- | ...and the means to run computations in it
runApp :: forall a. AppExcVM () a -> Environment -> Aff a
runApp = runAppExcVM (RProxy :: _ ())
  where
    runAppExcVM :: forall var rl.
      RowToList var rl =>
      VariantTags rl =>
      VariantShows rl =>
      RProxy var ->
      AppExcVM var a ->
      Environment ->
      Aff a
    runAppExcVM _ (AppExcVM appExcVM) env = do
      ran <- runExceptT $ runReaderT appExcVM env
      case ran of
        Right result -> pure result
        Left err     -> throwError $ error $ show err

-- | Layer 1 all the instances for the AppExcVM monad
derive newtype instance monadAffAppExcVM    :: MonadAff (AppExcVM var)
derive newtype instance monadEffectAppExcVM :: MonadEffect (AppExcVM var)
derive newtype instance monadAppExcVM       :: Monad (AppExcVM var)
derive newtype instance applicativeAppExcVM :: Applicative (AppExcVM var)
derive newtype instance applyAppExcVM       :: Apply (AppExcVM var)
derive newtype instance functorAppExcVM     :: Functor (AppExcVM var)
derive newtype instance bindAppExcVM        :: Bind (AppExcVM var)
derive newtype instance monadErrorAppExcVM  :: MonadThrow (Variant var) (AppExcVM var)

-- | Capability instances
instance monadHttpAppExcVM :: MonadHttp (AppExcVM var)

instance monadFSAppExcVM   :: MonadFs (AppExcVM var)

instance monadAskAppExcVM :: TypeEquals e1 Environment => MonadAsk e1 (AppExcVM v) where
  ask = AppExcVM $ asks from

instance loggerAppExcVM :: Logger (AppExcVM var) where
  log msg = liftEffect $ Console.log msg

instance getUserNameAppExcVM :: GetUserName (AppExcVM var) where
  getUserName = do
    env <- ask

    name <- safe $ (getPureScript env.url) # handleError (errorHandlersWithDefault "there was an error!")
  
    pure $ Name name

-- | an example of a function which combines the underlying services and thus
-- | has the possibility of raising errors from either one

getPureScript :: forall m r
  .  Monad m
  => MonadHttp m
  => MonadFs m
  => String -> ExceptV  (HttpError + FsError + r) m String
getPureScript url = do
  HTTP.get url >>= FS.write "~/purescript.html"
  pure "some result"


-- | this function is used to declutter the implementation of `getUserName`
-- | Provides exception handling functions for the _combined_ exceptions of HTTP and FS services
-- | such that the `ExceptV` can be entirely unwrapped, using `safe` from `checked-exceptions`
errorHandlersWithDefault :: forall m a.
  MonadEffect m =>
  a -> 
  { fsFileNotFound     :: String -> m a
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
