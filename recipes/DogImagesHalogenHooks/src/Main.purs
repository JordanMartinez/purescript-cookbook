module DogImagesHalogenHooks.Main where

import Prelude

import Affjax.ResponseFormat as AXRF
import Affjax.StatusCode (StatusCode(..))
import Affjax.Web as AX
import CSS (block, display, marginBottom, maxWidth, px, rem)
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
    getNextImage = do
      Hooks.put contentIdx RD.Loading
      errorOrResponse <- liftAff $ AX.request $ AX.defaultRequest
        { url = "https://dog.ceo/api/breeds/image/random"
        , method = Left GET
        , responseFormat = AXRF.json
        }
      let
        httpResult = case errorOrResponse of
          Right jsonRec | jsonRec.status == StatusCode 200 ->
            case decodeJson jsonRec.body of
              Right rec -> RD.Success rec.message
              _ -> RD.Failure "decode error"
          _ ->
            RD.Failure "http error"

      Hooks.put contentIdx httpResult

  Hooks.useLifecycleEffect do
    getNextImage
    pure Nothing

  Hooks.pure $
    HH.div_
      [ HH.h2_ [ HH.text "Random Dogs" ]
      , case content of
          RD.NotAsked ->
            HH.text "Loading page..."
          RD.Loading ->
            HH.text "Loading..."
          RD.Failure reason ->
            HH.div_
              [ HH.text "I could not load a random dog for some reason. "
              , HH.pre_ [ HH.text reason ]
              , HH.button
                  [ HE.onClick \_ -> getNextImage ]
                  [ HH.text "Try Again!" ]
              ]

          RD.Success url ->
            HH.div_
              [ HH.button
                  [ HE.onClick \_ -> getNextImage
                  , HC.style do
                      display block
                      marginBottom (1.0 # rem)
                  ]
                  [ HH.text "More Please!" ]
              , HH.img
                  [ HP.src url
                  , HC.style do
                      maxWidth (400.0 # px)
                  ]
              ]
      ]

decodeJson :: Json -> Either JsonDecodeError { message :: String, status :: String }
decodeJson = decode
  $ CA.object "response"
  $ CAR.record
      { message: CA.string
      , status: CA.string
      }
