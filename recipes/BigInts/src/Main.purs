module BigInts.Main where

import Prelude

import Data.BigInt (BigInt, fromBase, fromInt, pow, prime, toNumber)
import Data.Maybe (fromJust)
import Effect (Effect)
import Effect.Console (logShow)
import Partial.Unsafe (unsafePartial)

main :: Effect Unit
main = do
  logShow x
  logShow y
  logShow mersenne10
  logShow (x `pow` x)
  logShow (toNumber (y * mersenne10))
  logShow (prime mersenne10)

x :: BigInt
x = fromInt 42

y :: BigInt
y = unsafePartial $ (fromJust <<< fromBase 16) "fe45aab12"

mersenne10 :: BigInt
mersenne10 = (fromInt 2) `pow` (fromInt 89) - one
