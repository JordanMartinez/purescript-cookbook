module MemoizeFibonacci.Main where

import Prelude
import Data.Function.Memoize (memoize)
import Data.Interpolate (i)
import Debug.Trace (spy)
import Effect (Effect)
import Effect.Class.Console (log)

main :: Effect Unit
main = do
  log $ i "basic fib result: " $ fib 7
  log $ i "fibFast result: " $ fibFast 7
  log $ i "fibSlow result: " $ fibSlow 7

  -- The following variations type-check, but do not correctly memoize
  -- the functions. They are commented out intentionally. Uncomment them
  -- and run them to see for yourself.
  -- log $ i "fibBroken1 result: " $ fibBroken1 7
  -- log $ i "fibBroken2 result: " $ fibBroken2 7
  -- log $ i "fibBroken3 result: " $ fibBroken3 7

  -- Note: this one fails to compile.
  -- log $ i "fibBroken4 result: " $ fibBroken4 7

-- Basic fibonacci implementation
fib :: Int -> Int
fib 0 = 0
fib 1 = 1
fib n = fib (n - 2) + fib (n - 1)

--------------------------------------------------------------------------

-- Same as `fib`, but with `spy` statements added to reveal duplicated work
fibSlow :: Int -> Int
fibSlow 0 = spy "fibSlow 0" 0
fibSlow 1 = spy "fibSlow 1" 1
fibSlow n =
  spy ("fibSlow " <> show n)
    $ fibSlow (n - 2)
    + fibSlow (n - 1)

--------------------------------------------------------------------------

-- Fast memoized version of fibonacci
fibFast :: Int -> Int
fibFast 0 = spy "fibFast 0" 0
fibFast 1 = spy "fibFast 1" 1
fibFast n =
  spy ("fibFast " <> show n)
    $ fibMemo (n - 2)
    + fibMemo (n - 1)

fibMemo :: Int -> Int
fibMemo = memoize \n -> fibFast n

--------------------------------------------------------------------------
--------------------------------------------------------------------------

-- Broken due to the `memoize` function being written in a non-thunked form
fibBroken1 :: Int -> Int
fibBroken1 0 = spy "fibBroken1 0" 0
fibBroken1 1 = spy "fibBroken1 1" 1
fibBroken1 n =
  spy ("fibBroken1 " <> show n)
    $ fibNonThunkedMemoize (n - 2)
    + fibNonThunkedMemoize (n - 1)

fibNonThunkedMemoize :: Int -> Int
fibNonThunkedMemoize n = memoize fibBroken1 n

--------------------------------------------------------------------------

-- Broken due to using a let clause within the function body to define
-- memoized function rather than memoizing function outside of its body
fibBroken2 :: Int -> Int
fibBroken2 0 = spy "fibBroken2 0" 0
fibBroken2 1 = spy "fibBroken2 1" 1
fibBroken2 n =
  let
    fibLetClauseMemoize = memoize \n -> fibBroken2 n
  in spy ("fibBroken2 " <> show n)
    $ fibLetClauseMemoize (n - 2)
    + fibLetClauseMemoize (n - 1)

--------------------------------------------------------------------------

-- Broken due to using a where clause within the function body to define
-- memoized function rather than memoizing function outside of its body
fibBroken3 :: Int -> Int
fibBroken3 0 = spy "fibBroken3 0" 0
fibBroken3 1 = spy "fibBroken3 1" 1
fibBroken3 n =
  spy ("fibBroken3 " <> show n)
    $ fibWhereClauseMemoize (n - 2)
    + fibWhereClauseMemoize (n - 1)
  where
    fibWhereClauseMemoize = memoize \n -> fibBroken3 n

--------------------------------------------------------------------------

-- Note: This version fails to compile completely.

-- Broken due to the `memoize` function being written in a point-free form
-- fibBroken4 :: Int -> Int
-- fibBroken4 0 = spy "fibBroken4 0" 0
-- fibBroken4 1 = spy "fibBroken4 1" 1
-- fibBroken4 n =
--   spy ("fibBroken4 " <> show n)
--     $ fibPointFreeMemoize (n - 2)
--     + fibPointFreeMemoize (n - 1)
--
-- fibPointFreeMemoize :: Int -> Int
-- fibPointFreeMemoize = memoize fibBroken4
