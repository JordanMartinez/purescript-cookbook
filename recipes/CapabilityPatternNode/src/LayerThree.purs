module App.Layer.Three where -- Layers 4 & 3 common to Production and Test

import App.Layer.Four (Name, getName)
import Prelude (class Monad, Unit, bind, discard, pure, ($), (<>))

-- | Layer 3
-- | "business" logic: effectful functions

-- | Monads to define each capability required by the program
class (Monad m) <= Logger m where
    log :: String -> m Unit

class (Monad m) <= GetUserName m where
    getUserName :: m Name

-- | a program that will run in _any_ monad that can fulfill the
-- | requirements (Logger and GetUserName)
program :: forall m.
    Logger m =>
    GetUserName m =>
    m String
program = do
    log "what is your name?"
    name <- getUserName
    log $ "Your name is " <> getName name
    pure $ getName name
