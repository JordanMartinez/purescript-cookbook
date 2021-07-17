module ValueBasedJsonCodecLog.Main where

import Prelude

import Data.Argonaut.Core (Json, stringify)
import Data.Argonaut.Parser (jsonParser)
import Data.Bifunctor (class Bifunctor, lmap)
import Data.Codec (basicCodec, decode, encode)
import Data.Codec.Argonaut (JsonCodec, JsonDecodeError(..), printJsonDecodeError, (~))
import Data.Codec.Argonaut as CA
import Data.Codec.Argonaut.Common as CAM
import Data.Codec.Argonaut.Record as CAR
import Data.Either (Either(..), either, fromRight')
import Data.Int as Int
import Data.Maybe (Maybe(..))
import Data.Profunctor (dimap)
import Data.String (splitAt)
import Data.TraversableWithIndex (forWithIndex)
import Effect (Effect)
import Effect.Console (log, logShow)
import Partial.Unsafe (unsafeCrashWith)

main :: Effect Unit
main = do
  log "Verify codec is bidirectional"
  log "Rountrip 1: decode (encode x) == x:"
  let encodeDecodeValue = decode entireRecordCodec (encode entireRecordCodec exampleValue)
  case encodeDecodeValue of
    Left error -> log $ printJsonDecodeError error
    Right value -> logShow (value == exampleValue)

  log "Rountrip 2: encode (decode x) == x"
  let decodeEncodeValue = encode entireRecordCodec <$> (decode entireRecordCodec exampleJson)
  case decodeEncodeValue of
    Left error -> log $ printJsonDecodeError error
    Right value -> logShow (value == exampleJson)

  log "\n\n"

  log "Decoding the example JSON"
  either (log <<< printJsonDecodeError) logShow $
    decode entireRecordCodec exampleJson

  log "\n"

  log $ "Encoding the example value:"
  log $ stringify $ encode entireRecordCodec exampleValue

exampleJson :: Json
exampleJson = fromRight' (\_ -> unsafeCrashWith "got Left: bad parser") $ jsonParser
  """
  {
    "string":"string value",
    "boolean": true,
    "int": 4,
    "number": 42.0,
    "array": [
      "elem 1",
      "elem 2",
      "elem 3"
    ],
    "record": {
      "foo": "bar",
      "baz": 8
    },
    "sumTypesNoTags": [
      "Nothing",
      "Just 1"
    ],
    "sumTypeWithTags": [
      {"tag": "Nothing"},
      {"tag": "Just", "value": 1}
    ],
    "productTypesNoLabels": [
      1,
      true,
      "stuff"
    ],
    "productTypesWithLabels": {
      "key1": 1,
      "key2": true,
      "key3": "stuff"
    }
  }
  """

type EntireRecord =
  { string :: String
  , boolean :: Boolean
  , int :: Int
  , number :: Number
  , array :: Array String
  , record :: { foo :: String, baz :: Int }
  , sumTypesNoTags :: Array (Maybe Int)
  , sumTypeWithTags :: Array (Maybe Int)
  , productTypesNoLabels :: IntBooleanString
  , productTypesWithLabels :: IntBooleanString
  }

-- Note: Show instance appears at end of file
data IntBooleanString =
  IntBooleanString Int Boolean String

entireRecordCodec :: JsonCodec EntireRecord
entireRecordCodec =
  CAR.object "EntireRecord"
    { string: CA.string
    , boolean: CA.boolean
    , int: CA.int
    , number: CA.number
    , array: CA.array CA.string
    , record: CAR.object "record"
        { foo: CA.string
        , baz: CA.int
        }
    , sumTypesNoTags
    , sumTypeWithTags: CA.array $ CAM.maybe CA.int
    , productTypesNoLabels: CA.indexedArray "productTypesNoLabels" $
        (\i b s -> IntBooleanString i b s)
          <$> (\(IntBooleanString i _ _) -> i) ~ CA.index 0 CA.int
          <*> (\(IntBooleanString _ b _) -> b) ~ CA.index 1 CA.boolean
          <*> (\(IntBooleanString _ _ s) -> s) ~ CA.index 2 CA.string
    , productTypesWithLabels: do
        let
          encode :: IntBooleanString -> { key1 :: Int, key2 :: Boolean, key3 :: String }
          encode (IntBooleanString i b s) = { key1: i, key2: b, key3: s }

          decode :: { key1 :: Int, key2 :: Boolean, key3 :: String }
                 -> IntBooleanString
          decode {key1, key2, key3} = (IntBooleanString key1 key2 key3)

        dimap encode decode $ CAR.object "productTypesWithLabels"
          { key1: CA.int
          , key2: CA.boolean
          , key3: CA.string
          }
    }
  where
    sumTypesNoTags :: JsonCodec (Array (Maybe Int))
    sumTypesNoTags = basicCodec decodeArray encodeArray
      where
        encodeArray :: Array (Maybe Int) -> Json
        encodeArray arrayMaybeInt = do
          let arrayOfString = arrayMaybeInt <#> case _ of
                Nothing -> "Nothing"
                Just i -> "Just " <> show i
          encode (CA.array CA.string) arrayOfString

        lmapFlipped :: forall f a b c. Bifunctor f => f a c -> (a -> b) -> f b c
        lmapFlipped = flip lmap

        decodeArray :: Json -> Either JsonDecodeError (Array (Maybe Int))
        decodeArray jsonArray = do
          arrayOfJson <- decode (CA.array CA.json) jsonArray
          forWithIndex arrayOfJson \idx jsonValue -> do
            decodeValue jsonValue `lmapFlipped` \lowerLevelError ->
              Named "decodeArray" $ Named "forWithIndex" $ AtIndex idx lowerLevelError

        decodeValue :: Json -> Either JsonDecodeError (Maybe Int)
        decodeValue jsonValue = do
          str <- decode CA.string jsonValue
          case str of
            "Nothing" -> pure Nothing
            somethingElse -> case splitAt 5 somethingElse of
              { before: "Just ", after: intValue } ->
                case Int.fromString intValue of
                  Nothing -> Left $ TypeMismatch $
                              "Expected 'Just <int>', \
                              \but got 'Just " <> intValue <> "'"
                  justI -> pure justI
              _ ->
                Left $ UnexpectedValue jsonValue


exampleValue :: EntireRecord
exampleValue =
  { string: "string value"
  , boolean: true
  , int: 4
  , number: 42.0
  , array: ["elem 1", "elem 2", "elem 3"]
  , record: { foo: "bar", baz: 8 }
  , sumTypesNoTags: [ Nothing, Just 1 ]
  , sumTypeWithTags: [ Nothing, Just 1 ]
  , productTypesNoLabels: IntBooleanString 1 true "stuff"
  , productTypesWithLabels: IntBooleanString 1 true "stuff"
  }

instance showIntBooleanString :: Show IntBooleanString where
  show (IntBooleanString i b s) =
    "IntBooleanString(" <> show i <> " " <> show b <> " " <> show s <> ")"

derive instance eqIntBooleanString :: Eq IntBooleanString
