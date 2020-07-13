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
  let
    _typeLevelString :: SProxy "typeLevelString"
    _typeLevelString = SProxy

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
      [ Variant.inj _typeLevelString "a String value"
      , Variant.inj _intValue 4
      , Variant.inj _boolean true
      , Variant.inj _boolean false
      , Variant.inj (SProxy :: SProxy "this type level string must match the label of the row") 82.4
      ]

    _mustMatchLabelOfRow :: SProxy "this type level string must match the label of the row"
    _mustMatchLabelOfRow = SProxy

  log $ show heterogenousArray
  separateWithDashes

  log $ show $ map show heterogenousArray
  separateWithDashes

  let
    shownArray = heterogenousArray <#> \elem ->
      -- notice similarity to pattern match syntax via `case _ of`
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
