module BookReactHooks.Main where

import Prelude

import Affjax.ResponseFormat as ResponseFormat
import Affjax.StatusCode (StatusCode(..))
import Affjax.Web as Affjax
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception (throw)
import React.Basic.DOM (render)
import React.Basic.DOM as R
import React.Basic.Hooks (Component, component)
import React.Basic.Hooks as React
import React.Basic.Hooks.Aff (useAff)
import Web.HTML (window)
import Web.HTML.HTMLDocument (body)
import Web.HTML.HTMLElement (toElement)
import Web.HTML.Window (document)

data TextState
  = Failure
  | Success String

main :: Effect Unit
main = do
  body <- body =<< document =<< window
  case body of
    Nothing -> throw "Could not find body."
    Just b -> do
      bookComponent <- mkBookComponent
      render (bookComponent {}) (toElement b)

mkBookComponent :: Component {}
mkBookComponent = do
  let
    url = "https://elm-lang.org/assets/public-opinion.txt"
  component "Book" \_ -> React.do
    textState <-
      useAff unit do
        result <- Affjax.get ResponseFormat.string url
        pure case result of
          Right response
            | response.status == StatusCode 200 -> Success response.body
          _ -> Failure
    pure case textState of
      Nothing -> R.text "Loading..."
      Just Failure -> R.text "I was unable to load your book."
      Just (Success fullText) -> R.pre_ [ R.text fullText ]
