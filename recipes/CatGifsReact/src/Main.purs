module CatGifsReact.Main where

import Prelude
import Affjax (printError)
import Affjax as Affjax
import Affjax.ResponseFormat as ResponseFormat
import Data.Argonaut.Decode (decodeJson)
import Data.Argonaut.Decode.Combinators ((.:))
import Data.Array (singleton)
import Data.Bifunctor (lmap)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Exception (throw)
import React.Basic.DOM (css, render)
import React.Basic.DOM as R
import React.Basic.Events (handler_)
import React.Basic.Hooks (Component, component, useEffectOnce, (/\))
import React.Basic.Hooks as React
import React.Basic.Hooks.Aff (AffReducer, useAffReducer)
import Web.DOM.NonElementParentNode (getElementById)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.Window (document)

data GifState
  = Failure
  | Loading
  | Success String

data GifAction
  = MorePlease
  | GotGif (Either String String)

reducer :: AffReducer GifState GifAction
reducer state = case _ of
  MorePlease ->
    { state: Loading
    , effects: [ (singleton <<< GotGif) <$> getRandomCatGif ]
    }
  GotGif result -> case result of
    Right url -> { state: Success url, effects: [] }
    Left _ -> { state: Failure, effects: [] }

main :: Effect Unit
main = do
  container <- getElementById "root" =<< map toNonElementParentNode (document =<< window)
  case container of
    Nothing -> throw "Root element not found."
    Just c -> do
      catGifs <- mkCatGifs
      render (catGifs {}) c

mkCatGifs :: Component {}
mkCatGifs = do
  component "CatGifs" \_ -> React.do
    (gifState /\ dispatch) <- useAffReducer Loading reducer
    useEffectOnce do
      dispatch MorePlease
      pure mempty
    let
      onClick = handler_ (dispatch MorePlease)
    pure case gifState of
      Failure ->
        R.div_
          [ R.text "I could not load a random cat for some reason. "
          , R.button { onClick, children: [ R.text "Try Again!" ] }
          ]
      Loading -> R.text "Loading..."
      Success url ->
        R.div_
          [ R.button { onClick, style: css { display: "block" }, children: [ R.text "More Please!" ] }
          , R.img { src: url }
          ]

getRandomCatGif :: Aff (Either String String)
getRandomCatGif = do
  response <-
    Affjax.get
      ResponseFormat.json
      "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=cat"
  pure do
    { body } <- lmap printError response
    body' <- decodeJson body
    data' <- body' .: "data"
    data' .: "image_url"
