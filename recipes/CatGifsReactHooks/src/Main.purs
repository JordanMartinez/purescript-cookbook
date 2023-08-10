module CatGifsReactHooks.Main where

import Prelude

import Affjax.ResponseFormat as ResponseFormat
import Affjax.Web as Affjax
import Data.Argonaut.Decode (decodeJson, printJsonDecodeError)
import Data.Bifunctor (lmap)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Exception (throw)
import React.Basic.DOM (css)
import React.Basic.DOM as R
import React.Basic.DOM.Client (createRoot, renderRoot)
import React.Basic.Events (handler_)
import React.Basic.Hooks (Component, component, (/\))
import React.Basic.Hooks as React
import React.Basic.Hooks.Aff (useAff)
import React.Basic.Hooks.ResetToken (useResetToken)
import Web.DOM.NonElementParentNode (getElementById)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.Window (document)

main :: Effect Unit
main = do
  doc <- document =<< window
  root <- getElementById "root" $ toNonElementParentNode doc
  case root of
    Nothing -> throw "Could not find root."
    Just container -> do
      reactRoot <- createRoot container
      app <- mkApp
      renderRoot reactRoot (app {})

mkApp :: Component {}
mkApp = do
  component "CatGifs" \_ -> React.do
    resetToken /\ reset <- useResetToken
    response <- useAff resetToken getRandomCatGif

    let
      onClick = handler_ reset

    pure
      $ R.div_
          [ R.h2_ [ R.text "Random Cats" ]
          , case response of
              Nothing -> R.text "Loading..."
              Just (Left reason) ->
                R.div_
                  [ R.text "I could not load a random cat for some reason."
                  , R.pre_ [ R.text reason ]
                  , R.button { onClick, children: [ R.text "Try Again!" ] }
                  ]
              Just (Right url) ->
                R.div_
                  [ R.button
                      { onClick
                      , style: css { display: "block" }
                      , children: [ R.text "More Please!" ]
                      }
                  , R.img { src: url }
                  ]
          ]

getRandomCatGif :: Aff (Either String String)
getRandomCatGif = do
  response <-
    Affjax.get
      ResponseFormat.json
      "https://dog.ceo/api/breeds/image/random"
  let
    decodedResult = do
      { body } <- lmap Affjax.printError response
      decodedBody :: { message :: String, status :: String } <-
        lmap printJsonDecodeError (decodeJson body)
      if decodedBody.status == "success" then Right decodedBody.message
      else Left (show decodedBody)
  pure decodedResult
