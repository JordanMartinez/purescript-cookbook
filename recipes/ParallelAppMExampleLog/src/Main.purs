module ParallelAppMExampleLog.Main where

import Prelude

import Control.Parallel (class Parallel, parallel, sequential, parOneOf, parTraverse_)
import Control.Monad.Reader (class MonadAsk, ReaderT, asks, runReaderT)
import Data.Foldable (for_)
import Data.Int (toNumber)
import Data.Traversable (traverse)
import Data.Unfoldable (range)
import Effect (Effect)
import Effect.Aff (Aff, ParAff, Milliseconds(..), delay, launchAff_, parallel, sequential)
import Effect.Aff.Class (class MonadAff)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Console (log)
import Effect.Random (randomInt)
import Type.Equality (class TypeEquals, from)

-- Create an array from 1 to 10 as Strings.
array :: Array String
array = map show $ range 1 10

main :: Effect Unit
main =
  -- Starts running a computation and blocks until it finishes.
  let runComputation computationName computation = do
        liftEffect $ log $ "Running computation in 1 second: " <> computationName
        delay (Milliseconds 1000.0)
        computation

  in launchAff_ do
    runComputation "print all items in array sequentially" do
      for_ array \element -> do
        liftEffect $ log element

    let delayComputationWithRandomAmount = do
          delayAmount <- liftEffect $ randomInt 20 600
          delay $ Milliseconds $ toNumber delayAmount

    runComputation "print all items in array in parallel" do
      sequential $ for_ array \element -> do
        -- slow down speed of computation based on some random value
        -- to show that things are working in parallel.
        parallel do
          delayComputationWithRandomAmount
          liftEffect $ log element

    -- same computation as before but with less boilerplate.
    runComputation "print all items in array in parallel using parTraverse" do
      array # parTraverse_ \element -> do
        delayComputationWithRandomAmount
        liftEffect $ log element

    runComputation "race multiple computations & stop all others when one finishes" do
      let
        -- same as before
        arrayComputation index = do
          let shownIndex = "Array " <> show index <> ": "
          array # traverse \element -> do
            delayComputationWithRandomAmount
            liftEffect $ log $ shownIndex <> element

      void $ parOneOf [ arrayComputation 1
                      , arrayComputation 2
                      , arrayComputation 3
                      , arrayComputation 4
                      ]

-- Everything below this line is a copy of
-- the `AppM.purs` file (excluding imports)

-- Simple Environment info
type Env = { name :: String }

-- | The 'sequential' version of our application's monad.
-- | Base monad here is the 'sequential' version of Aff.
newtype AppM a = AppM (ReaderT Env Aff a)

runAppM :: Env -> AppM ~> Aff
runAppM env (AppM m) = runReaderT m env

instance monadAskAppM :: TypeEquals e Env => MonadAsk e AppM where
  ask = AppM $ asks from

derive newtype instance functorAppM :: Functor AppM
derive newtype instance applyAppM :: Apply AppM
derive newtype instance applicativeAppM :: Applicative AppM
derive newtype instance bindAppM :: Bind AppM
derive newtype instance monadAppM :: Monad AppM
derive newtype instance monadEffectAppM :: MonadEffect AppM
derive newtype instance monadAffAppM :: MonadAff AppM

-- | The 'parallel' version of our application's monad.
-- | The base monad here is the parallel version of `Aff`: `ParAff`
newtype ParAppM a = ParAppM (ReaderT Env ParAff a)

derive newtype instance functorParAppM :: Functor ParAppM
derive newtype instance applyParAppM :: Apply ParAppM
derive newtype instance applicativeParAppM :: Applicative ParAppM

-- Now we can implement Parallel for our AppM
-- by delegating it to the underlying base monads
instance parallelAppM :: Parallel ParAppM AppM where
  parallel (AppM readerT) = ParAppM $ parallel readerT

  sequential (ParAppM readerT) = AppM $ sequential readerT
