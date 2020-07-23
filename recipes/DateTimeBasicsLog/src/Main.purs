module DateTimeBasicsLog.Main where

import Prelude

import Data.Date (Date, Month(..), canonicalDate, exactDate)
import Data.DateTime (DateTime(..), adjust, diff)
import Data.Enum (toEnum)
import Data.Maybe (Maybe, fromJust)
import Data.Time (Hour, Minute, Time(..))
import Data.Time.Duration as D
import Effect (Effect)
import Effect.Console (log)
import Partial.Unsafe (unsafePartial)

main :: Effect Unit
main = do
  log "To create a specific part of a `Time` value, you must use \
      \the `toEnum` function. This ensures that the value you provide \
      \is within the correct bounds. "
  log "For example, a Minute must be between 0 and 59. If you happen \
      \to pass it -1, what should it's value be? Should it be clamped to 0? \
      \Or should it be set to 59? Rather than deciding for you, it forces \
      \you to do the checking by using `toEnum` to return a `Maybe Minute`."

  log $ "toEnum 4: " <> show (toEnum 4 :: Maybe Minute)
  log $ "toEnum -8: " <> show (toEnum (-8) :: Maybe Minute)
  log $ "toEnum 69: " <> show (toEnum 69 :: Maybe Minute)

  log "The same goes for Hour (0 - 23), Second (0 - 59), and \
      \Millisecond (0 - 999)."
  log $ "toEnum 4: " <> show (toEnum 4 :: Maybe Hour)
  log $ "toEnum -8: " <> show (toEnum (-8) :: Maybe Hour)
  log $ "toEnum 69: " <> show (toEnum 69 :: Maybe Hour)

  log "To create a `Time` value, you use the `Maybe` monad and do notation:"

  let
    mkTime :: Int -> Int -> Int -> Int -> Maybe Time
    mkTime h m s ms = do
      Time <$> toEnum h
           <*> toEnum m
           <*> toEnum s
           <*> toEnum ms

  log $ "mkTime 4 24 4 3: " <> show (mkTime 4 24 4 3)       -- valid
  log $ "mkTime 42 842 2 -42: " <> show (mkTime 42 842 2 (-42)) -- invalid

  log "To create a `Date` value, we use the `Maybe` monad again:"
  let
    mkCanonicalDate :: Int -> Month -> Int -> Maybe Date
    mkCanonicalDate year month day = ado
      year' <- toEnum year
      day' <- toEnum day
      in canonicalDate year' month day'

    mkExactDate :: Int -> Month -> Int -> Maybe Date
    mkExactDate year month day = do
      year' <- toEnum year
      day' <- toEnum day
      exactDate year' month day'

  log $ "mkCanonicalDate 2016 Feb 31: " <> show (mkCanonicalDate 2016 February 31)
  log $ "mkExactDate 2016 Feb 31: " <> show (mkExactDate 2016 February 31)
  log $ "mkExactDate 2016 Feb 27: " <> show (mkExactDate 2016 February 27)

  let
    mkDateTime :: Int -> Month -> Int -> Int -> Int -> Int -> Int -> Maybe DateTime
    mkDateTime y month d h m s ms = ado
      date' <- mkCanonicalDate y month d
      time' <- mkTime h m s ms
      in DateTime date' time'

  log $ "mkDateTime 2016 Feb 27 @ 11:04:14:423: " <>
    show (mkDateTime 2016 February 27 11 4 14 423)

  let
    dateTimeValue :: DateTime
    dateTimeValue = unsafePartial $ fromJust $
      mkDateTime 2016 February 27 11 4 14 423

  log $ "Original DateTime: " <> show dateTimeValue
  log $ "Add five seconds: " <> show (adjust (D.Seconds 5.0) dateTimeValue)
  log $ "Add two days: " <> show (adjust (D.Days 2.0) dateTimeValue)
  log $ "Add four hours: " <> show (adjust (D.Hours 4.0) dateTimeValue)

  let
    oneDayDifference = unsafePartial $ fromJust $
      adjust (D.Days 1.0) dateTimeValue

    result :: D.Days
    result = diff oneDayDifference dateTimeValue

  log $ "Number of Days between two dateTimes: " <> show result
