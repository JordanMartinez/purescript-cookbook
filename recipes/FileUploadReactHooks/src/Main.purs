module FileUploadReactHooks.Main where

import Prelude

import Data.Foldable (for_)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception (throw)
import React.Basic.DOM as R
import React.Basic.DOM.Client (createRoot, renderRoot)
import React.Basic.DOM.Events (currentTarget)
import React.Basic.Events (handler)
import React.Basic.Hooks (Component, component, fragment, useState', (/\))
import React.Basic.Hooks as React
import Web.DOM.NonElementParentNode (getElementById)
import Web.File.File as File
import Web.File.FileList as FileList
import Web.HTML (window)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.HTMLInputElement as HTMLInputElement
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
  component "FileUploadComponent" \_ -> React.do
    fileList /\ setFileList <- useState' []
    let
      handleChange t =
        for_ (HTMLInputElement.fromEventTarget t) \fileInput -> do
          maybeFiles <- HTMLInputElement.files fileInput
          for_ maybeFiles (setFileList <<< map File.name <<< FileList.items)
    pure
      $ fragment
          [ R.input
              { type: "file"
              , multiple: true
              , onChange: handler currentTarget handleChange
              }
          , R.pre_
              [ R.text (show fileList)
              ]
          ]
