module App.Application where -- Layers 4 & 3 common to Production and Test

import App.Types (Name, getName)
import Prelude (class Functor, Unit, bind, discard, identity, pure, unit, ($), (<>))
import Run (Run)
import Run as Run
import Type.Proxy (Proxy(..))
import Type.Row (type (+))

-- | Layer 3
-- | "business" logic: effectful functions

-- We define our capabilities as free dsls
data LoggerF a = Log String a
newtype GetUserNameF a = GetUserName (Name -> a)

-- We have to lift our free dsls into Run
log :: forall r. String -> Run (LOGGER + r) Unit
log str = Run.lift _logger $ Log str unit

getUserName :: forall r. Run (GET_USER_NAME + r) Name
getUserName = Run.lift _getUserName $ GetUserName identity

-- | A program which makes us of the dsls we defined earlier.
program :: forall r. Run (LOGGER + GET_USER_NAME + r) String
program = do
  log "what is your name?"
  name <- getUserName
  log $ "Your name is " <> getName name
  pure $ getName name

-- Free monads increase the boilerplate for defining the dsls 
-- but greatly reduce the boilerplate needed for writing different interpreters

derive instance loggerFunctor :: Functor LoggerF
derive instance getUserNameFunctor :: Functor GetUserNameF

type LOGGER r = (logger :: LoggerF | r)
type GET_USER_NAME r = (getUserName :: GetUserNameF | r)

_logger :: Proxy "logger"
_logger = Proxy

_getUserName :: Proxy "getUserName"
_getUserName = Proxy
