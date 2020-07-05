module BookReact.Main where

import Prelude
import Affjax as Affjax
import Affjax.ResponseFormat as ResponseFormat
import Affjax.StatusCode (StatusCode(..))
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Exception (throw)
import React.Basic.DOM (render)
import React.Basic.DOM as R
import React.Basic.Hooks (Component, component, useState', (/\))
import React.Basic.Hooks as React
import React.Basic.Hooks.Aff (useAff)
import Web.DOM.NonElementParentNode (getElementById)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.Window (document)

data TextState
  = Failure
  | Loading
  | Success String

main :: Effect Unit
main = do
  container <- getElementById "root" =<< map toNonElementParentNode (document =<< window)
  case container of
    Nothing -> throw "Root element not found."
    Just c -> do
      bookComponent <- mkBookComponent
      render (bookComponent {}) c

mkBookComponent :: Component {}
mkBookComponent = do
  let
    url = "https://elm-lang.org/assets/public-opinion.txt"
  component "Book" \_ -> React.do
    (textState /\ setTextState) <- useState' Loading
    useAff unit do
      result <- Affjax.get ResponseFormat.string url
      liftEffect case result of
        Right response
          | response.status == StatusCode 200 -> setTextState (Success response.body)
        _ -> setTextState Failure
    pure case textState of
      Failure -> R.text "I was unable to load your book."
      Loading -> R.text "Loading..."
      Success fullText -> R.pre_ [ R.text fullText ]
