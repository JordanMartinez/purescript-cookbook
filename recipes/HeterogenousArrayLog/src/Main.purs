module HeterogenousArrayLog.Main where

import Prelude
import Data.Functor.Variant (SProxy(..))
import Data.Variant (Variant)
import Data.Variant as Variant
import Effect (Effect)
import Effect.Class.Console (logShow)
import Effect.Console (log)

main :: Effect Unit
main = do
  log "---- Using Sum Type ----"
  heterogenousArrayViaSumType
  log "\n---- Using Variant Type ----"
  heterogenousArrayViaVariant

-------------- Sum Type Example --------------
--
-- Sum Type for array elements
data SumType
  = Str String
  | Integer Int
  | Bool Boolean
  | Num Number

heterogenousArrayViaSumType :: Effect Unit
heterogenousArrayViaSumType = do
  let
    -- Create array
    heterogenousArray :: Array SumType
    heterogenousArray =
      [ Str "a String value"
      , Integer 4
      , Bool true
      , Bool false
      , Num 82.4
      ]

    -- Demonstrate how to process array elements with a function
    -- that converts values of our SumType to strings for logging.
    -- Note, you could create a Show instance for SumType instead.
    showElement :: SumType -> String
    showElement = case _ of
      Str s -> s
      Integer i -> show i
      Bool b -> show b
      Num n -> show n
  --
  -- Show array
  logShow $ map showElement heterogenousArray

-------------- Variant Type Example --------------
--
-- Variant Type for array elements
-- Created from a "row type" of tags and other types
type VariantType
  = Variant
      ( typeLevelString :: String
      , int :: Int
      , boolean :: Boolean
      , "this type level string must match the label of the row" :: Number
      )

heterogenousArrayViaVariant :: Effect Unit
heterogenousArrayViaVariant = do
  let
    -- Setup some SProxy values with types matching those found within our VariantType
    --
    -- Read: "This particular `SProxy` value has the type
    -- `SProxy "typeLevelString"`..."
    _typeLevelString :: SProxy "typeLevelString"
    _typeLevelString = SProxy

    -- ... which differs from `SProxy "int"` and the other SProxy types below.
    -- Note that we can write these on one line as:
    _intValue = (SProxy :: SProxy "int")

    -- This shorthand style is also allowed:
    _boolean = (SProxy :: _ "boolean")

    -- Any string may be used as a type-level label
    _arbitraryTypeLevelString = (SProxy :: _ "this type level string must match the label of the row")

    -- Create array
    heterogenousArray :: Array VariantType
    heterogenousArray =
      -- To create a value of type `Variant`, we must inject a value into
      -- the data type using a type-level string that refers to the
      -- corresponding row (i.e. a label-type association)
      [ Variant.inj _typeLevelString "a String value"
      , Variant.inj _intValue 4
      , Variant.inj _boolean true
      -- You may also skip creating the SProxy helper values, and just write them inline:
      , Variant.inj (SProxy :: _ "boolean") false
      , Variant.inj _arbitraryTypeLevelString 82.4
      ]

    -- Demonstrate how to process array elements with a function
    -- that converts values of our VariantType to strings for logging.
    -- Note, you could create a Show instance for VariantType instead.
    showElement :: VariantType -> String
    showElement =
      Variant.case_
        # Variant.on _typeLevelString identity
        # Variant.on (SProxy :: _ "int") show -- inline example
        # Variant.on _boolean show
        # Variant.on _arbitraryTypeLevelString show
  --
  -- Show array
  logShow $ map showElement heterogenousArray
