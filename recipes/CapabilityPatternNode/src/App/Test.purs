module App.Test where
-- Layers 1 & 2 must be in same module due to orphan instance restriction

import Prelude

import App.Types (Name(..))
import App.Application (class Logger, class GetUserName)
import Control.Monad.Reader (Reader, runReader)

-- | Layer 2 Define our "Test" Monad...

type Environment = { testEnv :: String }
newtype TestM a = TestM (Reader Environment a)

-- | ...and the means to run computations in it
runApp :: forall a. TestM a -> Environment -> a
runApp (TestM reader) env = runReader reader env

-- | Layer 1 Provide instances for all capabilities needed
-- | Many of the instances are provided by deriving from the 
-- | underlying Reader...
derive newtype instance functorTestM     :: Functor TestM
derive newtype instance applyTestM       :: Apply TestM
derive newtype instance applicativeTestM :: Applicative TestM
derive newtype instance bindTestM        :: Bind TestM
derive newtype instance monadTestM       :: Monad TestM

-- | Test doesn't have access to Effect so can't log to console
instance loggerTestM :: Logger TestM where
  log _ = pure unit -- do nothing in test instance

instance getUserNameTestM :: GetUserName TestM where
  getUserName = pure $ Name "succeeds" -- replace with better test
