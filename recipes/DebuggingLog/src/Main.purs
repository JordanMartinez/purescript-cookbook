module DebuggingLog.Main where

import Prelude

import Control.Monad.ST as ST
import Control.Monad.ST.Internal as ST
import Control.Parallel (parSequence)
import Data.Int (toNumber)
import Data.Tuple (Tuple(..))
import Debug.Trace (spy, traceM)
import Effect (Effect)
import Effect.Aff (Milliseconds(..), delay, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Random (randomInt)

data MyADT = MyADT Int (Tuple Int (Array String)) { foo :: String }

main :: Effect Unit
main = do
  log "When we are in the 'Effect' monad, we can print content to the console."
  launchAff_ do
    liftEffect $ log $ "We can still print values to the console as long as \
                       \the monad in question implements the MonadEffect \
                       \type class. Since `Aff` implements MonadEffect, we \
                       \can lift that effect into `Aff`."

  log "However, there are times when we want to debug some code and wish \
      \to use print-based debugging. Since PureScript is pure, how do we \
      \do that?"

  usingSpy

  usingTraceMInEffect
  usingTraceMInST
  usingTraceMInAff
  usingTraceMInAffRace

usingSpy :: Effect Unit
usingSpy = do
  log "usingSpy"
  -- `spy` returns the value it receives. However, it prints that value
  -- to the console before it "returns."
  --    spy :: forall a. DebugWarning => String -> a -> a
  -- You can use this in a `let` clause pretty reliably
  let
    x = 5
    y = spy "y" 8
    adt = spy "adt" $ MyADT 1 (Tuple 4 ["a", "b"]) { foo: "foo value" }
    function = spy "function" $ \intValue -> show $ 4 + intValue

    -- quick way of debugging something without showing it or using a
    -- variable name
    _ = spy "debug for me what x + y is" $ x + y
    arrayOfStrings = spy "debug some array" $ map show [1, 2, 3, 4, 5]

    -- quickly drop-in `spy` to see every step of a recursive function
    fact :: Int -> Int -> Int
    fact 0 acc = acc
    fact n acc = fact (spy "n" (n - 1)) (spy "acc" (acc * n))

    _ = fact 5 1

  launchAff_ do
    let
      y = spy "y in Aff" 8
      adt = spy "adt in Aff" $ MyADT 1 (Tuple 4 ["a", "b"]) { foo: "foo value" }
      function = spy "function in Aff" $ \intValue -> show $ 4 + intValue
    pure unit

  log $ "Thus, spying is an effective way of quickly adding debugging where \
        \you need it without affecting any other part of your code. \
        \Note: you should not do this in production code. Use a proper logger \
        \in production code."

usingTraceMInEffect :: Effect Unit
usingTraceMInEffect = do
  log "usingTraceMInEffect"
  log "But what if you don't want to depend on `console` to do temporary \
      \printing-based debugging? We can use traceM instead."
  traceM "logging to the console without using `log`"

usingTraceMInST :: Effect Unit
usingTraceMInST = do
  let localMutationResult = ST.run do
        localReference <- ST.new 0
        traceM localReference
        four <- ST.modify (_ + 4) localReference
        traceM four
        ST.write (four + 2) localReference
  log $ "Local reference value is: " <> show localMutationResult

usingTraceMInAff :: Effect Unit
usingTraceMInAff = do
  launchAff_ do
    pure unit
    traceM 5
    pure unit

usingTraceMInAffRace :: Effect Unit
usingTraceMInAffRace = do
  launchAff_ do
    parSequence [ runXTimes 4 $ genValueTraceMNo $ spy "which fiber id" 1
                , runXTimes 4 $ genValueTraceMYes 2
                , runXTimes 4 $ genValueTraceMYes 3
                , runXTimes 4 $ genValueTraceMYes 4
                , runXTimes 4 $ genValueTraceMNo 5
                , runXTimes 4 $ genValueSpy 5
                ]

  where
    runXTimes 1 comp = comp
    runXTimes n comp = comp *> runXTimes (n - 1) comp

    genValueTraceMNo _ = do
      randomValue <- liftEffect $ randomInt 1 10
      delay $ Milliseconds $ toNumber randomValue
      pure unit

    genValueTraceMYes i = do
      randomValue <- liftEffect $ randomInt 1 10
      delay $ Milliseconds $ toNumber randomValue
      traceM $ "Fiber: " <> show i <> " - random value: " <> show randomValue
      pure unit

    genValueSpy i = do
      randomValue <- liftEffect $ randomInt 1 10
      delay $ Milliseconds $ toNumber $ spy "(spy) random value" randomValue
      pure unit
