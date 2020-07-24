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

-- Basic fibonacci implementation
fib :: Int -> Int
fib 0 = 0
fib 1 = 1
fib n = fib (n - 2) + fib (n - 1)

-- Same as `fib`, but with `spy` statements added to reveal duplicated work
fibSlow :: Int -> Int
fibSlow 0 = spy "fibSlow 0" 0
fibSlow 1 = spy "fibSlow 1" 1
fibSlow n =
  spy ("fibSlow " <> show n)
    $ fibSlow (n - 2)
    + fibSlow (n - 1)

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

{-
Note that the following adjustments to `fibMemo` eliminate the
performance benefits of `memoize`, even though they may still
type-check. Feel free to experiment with these yourself:

* Rewrite in non-thunked or point-free form:
  * `fibMemo n = memoize fibFast n`
  * `fibMemo = memoize fibFast`
* Move to a `let` or `where` clause inside of `fibFast`.
-}
