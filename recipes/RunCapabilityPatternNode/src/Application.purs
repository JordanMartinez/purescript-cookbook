module App.Application where -- Layers 4 & 3 common to Production and Test

import App.Types (Name, getName)
import Data.Symbol (SProxy(..))
import Data.Variant.Internal (FProxy)
import Prelude (class Functor, Unit, bind, discard, identity, pure, unit, ($), (<>))
import Run (Run)
import Run as Run

-- | Layer 3
-- | "business" logic: effectful functions

-- We define our capabilities as free dsls
data LoggerF a = Log String a
newtype GetUserNameF a = GetUserName (Name -> a)

-- We have to lift our free dsls into Run
log :: forall r. String -> Run ( logger :: LOGGER | r ) Unit
log str = Run.lift _logger $ Log str unit

getUserName :: forall r. Run ( getUserName :: GET_USER_NAME | r ) Name
getUserName = Run.lift _getUserName $ GetUserName identity

-- | A program which makes us of the dsls we defined earlier.
program :: forall r. Run ( logger :: LOGGER, getUserName :: GET_USER_NAME | r ) String
program = do
    log "what is your name?"
    name <- getUserName
    log $ "Your name is " <> getName name
    pure $ getName name

-- Free monads increase the boilerplate for defining the dsls 
-- but greatly reduce the boilerplate needed for writing different interpreters


derive instance loggerFunctor :: Functor LoggerF
derive instance getUserNameFunctor :: Functor GetUserNameF

type LOGGER = FProxy LoggerF
type GET_USER_NAME = FProxy GetUserNameF

_logger :: SProxy "logger"
_logger = SProxy

_getUserName :: SProxy "getUserName"
_getUserName = SProxy