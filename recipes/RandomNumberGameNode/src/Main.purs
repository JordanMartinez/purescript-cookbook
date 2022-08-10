module RandomNumberGameNode.Main where

import Prelude

import Control.Monad.Reader (class MonadAsk, ReaderT, ask, asks, runReaderT)
import Data.Array (elem, snoc)
import Data.Either (Either(..))
import Data.Int (fromString)
import Data.Interpolate (i)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff, makeAff, nonCanceler, runAff_)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Class.Console (log)
import Effect.Random (randomInt)
import Effect.Ref (Ref)
import Effect.Ref as Ref
import Node.ReadLine (Interface, close, createConsoleInterface, noCompletion)
import Node.ReadLine as NRL
import Type.Equality (class TypeEquals, from)

main :: Effect Unit
main = do
  -- get/create environment values
  interface <- createConsoleInterface noCompletion
  randomNumber <- randomInt 1 10
  remainingGuesses <- Ref.new 4
  previousGuesses <- Ref.new []

  let env = { randomNumber, remainingGuesses, previousGuesses, interface }

  -- now run our game using custom monad
  runAff_
    (\_ -> close interface)
    (runAppM env game)

-- All the impure API our monad needs to support to run the program
-- Normally, this would be broken up into more type classes for higher
-- granularity.
class (Monad m) <= GameCapabilities m where
  notifyUser :: String -> m Unit
  getUserInput :: String -> m String

  getRandomNumber :: m Int

  getRemainingGuesses :: m Int

  getPreviousGuesses :: m (Array Int)

  storeGuess :: Int -> m Unit

-- Game logic using only the above capabilities
game
  :: forall m
   . GameCapabilities m
  => m Unit
game = do
  remaining <- getRemainingGuesses
  notifyUser $ i "Guess the random number. It's between 1 and 10. You have "
    (remaining + 1)
    " guesses. Enter 'q' to quit. \
    \Invalid inputs will not count against you."

  result <- gameLoop

  case result of
    PlayerWins correctAnswer remainingGuesses -> do
      notifyUser $ i "Player won! The answer was " correctAnswer
      notifyUser $ i "Player guessed the random number with " remainingGuesses
        " guesses remaining."
    PlayerLoses correctAnswer allGuessesMade -> do
      notifyUser $ i "Player lost! The answer was " correctAnswer
      notifyUser $ i "Guesses made: " (show allGuessesMade)
    PlayerQuits -> do
      notifyUser "Player quit the game. Bye!"

-- This function is normally NOT stack-safe because of its recursive nature.
-- However, as long as the base/foundational monad is `Aff`, which is always
-- stack-safe, we don't have to worry about this concern.
gameLoop :: forall m. GameCapabilities m => m GameResult
gameLoop = do
  prev <- getPreviousGuesses
  notifyUser $ i
    "\n\
    \Prevous guesses: "
    (show prev)
  nextInput <- getUserInput "Guess a number between 1 - 10: "
  case nextInput of
    "q" -> pure PlayerQuits
    x -> case fromString x of
      Nothing -> do
        notifyUser $ i "'" x "' is not an integer. Try again (Use 'q' to quit)."
        gameLoop
      Just guess
        | not (between 1 10 guess) -> do
            notifyUser $ i guess " was not between 1 and 10. Try again."
            gameLoop
        | elem guess prev -> do
            notifyUser $ i "You already guessed " guess
              " previously. \
              \Please guess a different number."
            gameLoop
        | otherwise -> do
            answer <- getRandomNumber
            if (guess == answer) then do
              remaining <- getRemainingGuesses
              pure $ PlayerWins guess remaining
            else do
              remaining <- getRemainingGuesses
              if remaining <= 0 then do
                pure $ PlayerLoses answer (prev `snoc` guess)
              else do
                storeGuess guess
                gameLoop

data GameResult
  = PlayerWins Int Int
  | PlayerLoses Int (Array Int)
  | PlayerQuits

-- ReaderT Design Pattern

type Environment =
  { randomNumber :: Int
  , interface :: Interface
  , remainingGuesses :: Ref Int
  , previousGuesses :: Ref (Array Int)
  }

newtype AppM a = AppM (ReaderT Environment Aff a)

-- Given an Environment value, we can convert an `AppM` computation
-- into an `Aff` computation.
runAppM :: Environment -> AppM ~> Aff
runAppM env (AppM m) = runReaderT m env

derive newtype instance functorAppM :: Functor AppM
derive newtype instance applicativeAppM :: Applicative AppM
derive newtype instance applyAppM :: Apply AppM
derive newtype instance bindAppM :: Bind AppM
derive newtype instance monadAppM :: Monad AppM
derive newtype instance monadEffectAppM :: MonadEffect AppM
derive newtype instance monadAffAppM :: MonadAff AppM

-- Since Environment is a type alias, we need to use `TypeEquals`
-- to make this work without newtyping Envirnoment.
-- This limitation will likely be removed in a future PS release
instance monadAskAppM :: TypeEquals e Environment => MonadAsk e AppM where
  ask = AppM $ asks from

-------------------------

instance gameCapabilitiesAppM :: GameCapabilities AppM where
  notifyUser :: String -> AppM Unit
  notifyUser = log

  getUserInput :: String -> AppM String
  getUserInput prompt = do
    iface <- asks _.interface
    -- Note: `purescript-node-readline-aff` isn't in the package set,
    -- so we'll reimplement `question` in this file.
    liftAff $ question prompt iface

  getRandomNumber :: AppM Int
  getRandomNumber = asks _.randomNumber

  getRemainingGuesses :: AppM Int
  getRemainingGuesses = asks _.remainingGuesses >>= (liftEffect <<< Ref.read)

  getPreviousGuesses :: AppM (Array Int)
  getPreviousGuesses = asks _.previousGuesses >>= (liftEffect <<< Ref.read)

  storeGuess :: Int -> AppM Unit
  storeGuess guess = do
    rec <- ask
    liftEffect do
      Ref.modify_ (_ - 1) rec.remainingGuesses
      Ref.modify_ (\a -> a `snoc` guess) rec.previousGuesses

-- Provides an Aff wrapper around Node.Readline.question
question :: String -> Interface -> Aff String
question prompt iface =
  makeAff \runCallback -> do
    NRL.question prompt (\value -> runCallback (Right value)) iface
    pure nonCanceler
