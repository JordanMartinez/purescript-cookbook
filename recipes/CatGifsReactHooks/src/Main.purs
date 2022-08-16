module CatGifsReactHooks.Main where

import Prelude

import Affjax.ResponseFormat as ResponseFormat
import Affjax.Web as Affjax
import Data.Argonaut.Decode (decodeJson)
import Data.Argonaut.Decode.Combinators ((.:))
import Data.Either (hush)
import Data.Maybe (Maybe(..), maybe)
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

data GifState
  = Failure
  | Loading
  | Success String

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
    (resetToken /\ reset) <- useResetToken
    gifState <- toGifState <$> useAff resetToken getRandomCatGif
    let onClick = handler_ reset
    pure
      $ R.div_
          [ R.h2_ [ R.text "Random Cats" ]
          , case gifState of
              Loading -> R.text "Loading..."
              Failure ->
                R.div_
                  [ R.text "I could not load a random cat for some reason."
                  , R.button { onClick, children: [ R.text "Try Again!" ] }
                  ]
              Success url ->
                R.div_
                  [ R.button
                      { onClick
                      , style: css { display: "block" }
                      , children: [ R.text "More Please!" ]
                      }
                  , R.img { src: url }
                  ]
          ]

-- | Collapse nested `Maybe`s to our `GifState` type
toGifState :: Maybe (Maybe String) -> GifState
toGifState = maybe Loading (maybe Failure Success)

getRandomCatGif :: Aff (Maybe String)
getRandomCatGif = do
  response <-
    Affjax.get
      ResponseFormat.json
      "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=cat"
  pure do
    -- Using `hush` to ignore the possible error messages
    { body } <- hush response
    hush
      ( decodeJson body
          >>= (_ .: "data")
          >>= (_ .: "images")
          >>= (_ .: "downsized")
          >>= (_ .: "url")
      )
