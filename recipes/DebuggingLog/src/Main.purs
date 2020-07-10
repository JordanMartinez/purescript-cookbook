module DebuggingLog.Main where

import Prelude

import Control.Monad.ST.Internal as ST
import Data.Tuple (Tuple(..))
import Debug.Trace (spy, traceM)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)

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

  usingTraceM

  compareSpyAndTraceM

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

  log $ "Thus, spying is an effective way of quickly adding debugging where \
        \you need it without affecting any other part of your code. \
        \Note: you should not use `spy` to do logging in production code. \
        \Use a proper logger in production code."

usingTraceM :: Effect Unit
usingTraceM = do
  log "usingTraceM"
  traceM "Notice how this text's color is different than what is outputted \
         \via `log`."

  let
    localMutationComputation
      :: forall ensureMutationStaysLocal. ST.ST ensureMutationStaysLocal Int
    localMutationComputation = do
      -- the ST monad does not implement `MonadEffect`,
      -- so `traceM` is the only way to log output to the console in a
      -- `log`-like fashion.
      localReference <- ST.new 0
      traceM localReference
      four <- ST.modify (_ + 4) localReference
      traceM four
      ST.write (four + 2) localReference

  log $ "Local reference value is: " <> show (ST.run localMutationComputation)

compareSpyAndTraceM :: Effect Unit
compareSpyAndTraceM = do
  let x = 5
      _ = spy "x" x
  traceM x
