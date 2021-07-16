module InterpretHalogenHooks.Main where

import Prelude

import Affjax as AX
import Affjax.ResponseFormat as AXRF
import Control.Monad.Reader (ReaderT, ask, runReaderT)
import Data.Either (either)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Aff (Aff)
import Halogen (lift)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.Hooks as Hooks
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody
  runUI ui' unit body

ui' :: forall f i o. H.Component f i o Aff
ui' = H.hoist (\app -> runReaderT app { githubToken: Nothing }) uiComponent

type Config = { githubToken :: Maybe String }

uiComponent
  :: forall unusedInput unusedQuery unusedOutput
   . H.Component unusedQuery unusedInput unusedOutput (ReaderT Config Aff)
uiComponent = Hooks.component \rec _ -> Hooks.do
  state /\ stateIdx <- Hooks.useState (Nothing :: Maybe String)
  Hooks.pure $
    HH.div_
      [ HH.h1_
          [ HH.text "Fetch user data" ]
      , HH.button
          [ HE.onClick \_ -> do
              userData <- lift (searchUser "kRITZCREEK")
              Hooks.put stateIdx $ Just userData
          ]
          [ HH.text "Fetch" ]
      , HH.p_
          [ HH.text (fromMaybe "No user data" state) ]
      ]

searchUser :: String -> ReaderT Config Aff String
searchUser q = do
  { githubToken } <- ask
  result <- case githubToken of
    Nothing ->
      lift (AX.get AXRF.string ("https://api.github.com/users/" <> q))
    Just token ->
      lift (AX.get AXRF.string ("https://api.github.com/users/" <> q <> "?access_token=" <> token))
  pure (either (const "") _.body result)
