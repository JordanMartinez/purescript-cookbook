module HeterogenousArrayLog.Main where

import Prelude

import Data.Functor.Variant (SProxy(..))
import Data.Variant (Variant)
import Data.Variant as Variant
import Effect (Effect, foreachE)
import Effect.Console (log)

separateWithDashes :: Effect Unit
separateWithDashes = log "------------------"

main :: Effect Unit
main = do
  heterogenousArrayViaSumType

  separateWithDashes
  separateWithDashes

  heterogenousArrayViaVariant

data SumType
  = Str String
  | Integer Int
  | Bool Boolean
  | Num Number

instance showSumType :: Show SumType where
  show = case _ of
    Str s -> "Str(" <> s <> ")"
    Integer i -> "Integer(" <> show i <> ")"
    Bool b -> "Bool(" <> show b <> ")"
    Num n -> "Num(" <> show n <> ")"

heterogenousArrayViaSumType :: Effect Unit
heterogenousArrayViaSumType = do
  let
    heterogenousArray :: Array SumType
    heterogenousArray =
      [ Str "a String value"
      , Integer 4
      , Bool true
      , Bool false
      , Num 82.4
      ]

  -- works, but not quite what we want.
  log $ show heterogenousArray
  separateWithDashes

  -- better, but does incur some boilerplate
  log $ show $ heterogenousArray <#> \elem ->
    case elem of
      Str s -> s
      Integer i -> show i
      Bool b -> show b
      Num n -> show n
  separateWithDashes

  foreachE heterogenousArray \elem -> do
    log case elem of
      Str s -> "String value: " <> s
      Integer i -> "Int value: " <> show i
      Bool b -> "Boolean value: " <> show b
      Num n -> "Number value: " <> show n

heterogenousArrayViaVariant :: Effect Unit
heterogenousArrayViaVariant = do
  let
    -- Read: "This particular `SProxy` value has the type
    -- `SProxy "typeLevelString"`..."
    _typeLevelString :: SProxy "typeLevelString"
    _typeLevelString = SProxy

    -- ... which differs from `SProxy "int"` and the other SProxy types below.
    _intValue :: SProxy "int"
    _intValue = SProxy

    _boolean :: SProxy "boolean"
    _boolean = SProxy

    heterogenousArray
      :: Array (Variant
                  ( typeLevelString :: String
                  , int :: Int
                  , boolean :: Boolean
                  , "this type level string must match the label of the row" :: Number
                  ))
    heterogenousArray =
      -- To create a value of type `Variant`, we must inject a value into
      -- the data type using a type-level string that refers to the
      -- corresponding row (i.e. a label-type association)
      [ Variant.inj _typeLevelString "a String value"
      , Variant.inj _intValue 4
      , Variant.inj _boolean true
      , Variant.inj _boolean false
      , Variant.inj (SProxy :: SProxy "this type level string must match the label of the row") 82.4
      ]

  -- not quite what we want...
  log $ show heterogenousArray
  separateWithDashes

  -- a bit better, but still lacking...
  log $ show $ map show heterogenousArray
  separateWithDashes

  let
    _mustMatchLabelOfRow :: SProxy "this type level string must match the label of the row"
    _mustMatchLabelOfRow = SProxy

    shownArray :: Array String
    shownArray = heterogenousArray <#> \elem ->
      -- notice similarity to pattern match syntax via `case _ of`
      -- and that the parenthesis wraps the entire statement
      -- before we pass in the `elem` argument.
      (Variant.case_
        # Variant.on _typeLevelString show
        # Variant.on _intValue show
        # Variant.on _boolean show
        # Variant.on _mustMatchLabelOfRow show) elem

  log $ show shownArray
  separateWithDashes

  foreachE heterogenousArray \elem -> do
    log $
      (Variant.case_
        # Variant.on _typeLevelString (\str -> "String value: " <> str)
        # Variant.on _intValue (\i -> "Int value: " <> show i)
        # Variant.on _boolean (\b -> "Boolean value: " <> show b)
        # Variant.on _mustMatchLabelOfRow (\num -> "Number value: " <> show num))
        elem
