module CatGifsHalogenHooks.Main where

import Prelude

import Affjax.ResponseFormat as AXRF
import Affjax.StatusCode (StatusCode(..))
import Affjax.Web as AX
import CSS (block, display)
import Data.Argonaut.Core (Json)
import Data.Codec (decode)
import Data.Codec.Argonaut (JsonDecodeError)
import Data.Codec.Argonaut as CA
import Data.Codec.Argonaut.Record as CAR
import Data.Either (Either(..))
import Data.HTTP.Method (Method(..))
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Aff.Class (class MonadAff, liftAff)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.CSS as HC
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.Hooks as Hooks
import Halogen.VDom.Driver (runUI)
import Network.RemoteData as RD

main :: Effect Unit
main =
  HA.runHalogenAff do
    body <- HA.awaitBody
    void $ runUI hookComponent Nothing body

hookComponent
  :: forall unusedQuery unusedInput unusedOutput anyMonad
   . MonadAff anyMonad
  => H.Component unusedQuery unusedInput unusedOutput anyMonad
hookComponent = Hooks.component \_ _ -> Hooks.do
  content /\ contentIdx <- Hooks.useState RD.NotAsked

  let
    getNextGif = do
      Hooks.put contentIdx RD.Loading
      errorOrResponse <- liftAff $ AX.request $ AX.defaultRequest
        { url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=cat"
        , method = Left GET
        , responseFormat = AXRF.json
        }
      let
        httpResult = case errorOrResponse of
          Right jsonRec | jsonRec.status == StatusCode 200 ->
            case decodeJson jsonRec.body of
              Right rec -> RD.Success rec.data.images.downsized.url
              _ -> RD.Failure "decode error"
          _ ->
            RD.Failure "http error"

      Hooks.put contentIdx httpResult

  Hooks.useLifecycleEffect do
    getNextGif
    pure Nothing

  Hooks.pure $
    HH.div_
      [ HH.h2_ [ HH.text "Random Cats" ]
      , case content of
          RD.NotAsked ->
            HH.text "Loading page..."
          RD.Loading ->
            HH.text "Loading..."
          RD.Failure _ ->
            HH.div_
              [ HH.text "I could not load a random cat for some reason. "
              , HH.button
                  [ HE.onClick \_ -> getNextGif
                  ]
                  [ HH.text "Try Again!" ]
              ]

          RD.Success url ->
            HH.div_
              [ HH.button
                  [ HE.onClick \_ -> getNextGif
                  , HC.style $ display block
                  ]
                  [ HH.text "More Please!" ]
              , HH.img [ HP.src url ]
              ]
      ]

decodeJson :: Json -> Either JsonDecodeError { data :: { images :: { downsized :: { url :: String } } } }
decodeJson = decode
  $ CA.object "data"
  $ CAR.record
      { data: CA.object "images" $ CAR.record
          { images: CA.object "downsized" $ CAR.record
              { downsized: CA.object "url" $ CAR.record
                  { url: CA.string }
              }
          }
      }
