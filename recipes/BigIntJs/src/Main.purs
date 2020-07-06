module BigIntJs.Main where

import Prelude

import Data.BigInt (BigInt, fromBase, fromInt, fromNumber, pow, prime, toNumber, toString)
import Data.Int (floor)
import Data.Maybe (fromJust)
import Effect (Effect)
import Effect.Console (log)
import Partial.Unsafe (unsafePartial)

main :: Effect Unit
main = do
  log $ "Print via `show`: " <> show createValueFromInt
  log $ "Print via `toString`: " <> toString createValueFromInt
  log $ ""
  log $ "fromInt: " <> toString createValueFromInt
  log $ "fromBase: " <> toString createValueFromSpecificBase
  log $ ""
  log $ "Decimal is truncated when using `fromNumber`"
  log $ "fromNumber (1): " <> toString createValueFromNumber1
  log $ "fromNumber (2): " <> toString createValueFromNumber2
  log $ "fromNumber (3): " <> toString createValueFromNumber3
  log $ "fromNumber (4): " <> toString createValueFromNumber4
  log $ ""
  log $ "miscellaneous operations"
  log $ "x `pow` x: " <> toString (createValueFromInt `pow` createValueFromInt)
  log $ "toNumber (y * mersenne10): " <> show (toNumber (y * mersenne10))
  log $ "prime mersenne10: " <> show (prime mersenne10)
  log $ "big number: " <> toString ((x + y * mersenne10 - (fromInt 20413)) `pow` (fromInt 2))

createValueFromInt :: BigInt
createValueFromInt = fromInt 42

createValueFromSpecificBase :: BigInt
createValueFromSpecificBase = unsafePartial $ fromJust $ fromBase 16 "fe45aab12"

createValueFromNumber1 :: BigInt
createValueFromNumber1 = unsafePartial $ fromJust $ fromNumber 242424.0

createValueFromNumber2 :: BigInt
createValueFromNumber2 = unsafePartial $ fromJust $ fromNumber 242424.4

createValueFromNumber3 :: BigInt
createValueFromNumber3 = unsafePartial $ fromJust $ fromNumber 242424.8

-- This is probably the easier thing to do rather than using
-- `unsafePartial $ fromJust $ fromNumber <number>``
createValueFromNumber4 :: BigInt
createValueFromNumber4 = fromInt $ floor 242424.5

x :: BigInt
x = createValueFromInt

y :: BigInt
y = createValueFromSpecificBase

mersenne10 :: BigInt
mersenne10 = (fromInt 2) `pow` (fromInt 89) - one
