module BookHalogenHooks.Main where

import Prelude

import Affjax as AX
import Affjax.ResponseFormat as AXRF
import Affjax.StatusCode (StatusCode(..))
import Data.Either (Either(..))
import Data.HTTP.Method (Method(..))
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Aff.Class (class MonadAff, liftAff)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
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
  => H.Component HH.HTML unusedQuery unusedInput unusedOutput anyMonad
hookComponent = Hooks.component \_ _ -> Hooks.do
  content /\ contentIdx <- Hooks.useState RD.NotAsked

  Hooks.useLifecycleEffect do
    Hooks.put contentIdx RD.Loading
    errorOrResponse <- liftAff $ AX.request $ AX.defaultRequest
      { url = "https://elm-lang.org/assets/public-opinion.txt"
      , method = Left GET
      , responseFormat = AXRF.string
      }
    let
      httpResult = case errorOrResponse of
        Right rec | rec.status == StatusCode 200 ->
          RD.Success rec.body
        _ ->
          RD.Failure "http error"

    Hooks.put contentIdx httpResult

    pure Nothing

  Hooks.pure case content of
    RD.NotAsked ->
      HH.text "Still loading page..."
    RD.Loading ->
      HH.text "Loading..."
    RD.Failure _ ->
      HH.text "I was unable to load your book."
    RD.Success fullText ->
      HH.pre_ [ HH.text fullText ]
