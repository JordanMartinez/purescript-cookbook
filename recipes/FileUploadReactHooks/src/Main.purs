module FileUploadReactHooks.Main where

import Prelude
import Data.Foldable (for_)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception (throw)
import React.Basic.DOM (render)
import React.Basic.DOM as R
import React.Basic.DOM.Events (currentTarget)
import React.Basic.Events (handler)
import React.Basic.Hooks (Component, component, fragment, useState', (/\))
import React.Basic.Hooks as React
import Web.File.File as File
import Web.File.FileList as FileList
import Web.HTML (window)
import Web.HTML.HTMLDocument (body)
import Web.HTML.HTMLElement (toElement)
import Web.HTML.HTMLInputElement as HTMLInputElement
import Web.HTML.Window (document)

main :: Effect Unit
main = do
  body <- body =<< document =<< window
  case body of
    Nothing -> throw "Could not find body."
    Just b -> do
      fileUploadComponent <- mkFileUploadComponent
      render (fileUploadComponent {}) (toElement b)

mkFileUploadComponent :: Component {}
mkFileUploadComponent = do
  component "FileUploadComponent" \_ -> React.do
    fileList /\ setFileList <- useState' []
    let
      handleChange t = case HTMLInputElement.fromEventTarget t of
        Nothing -> pure unit
        Just fileInput -> do
          maybeFiles <- (HTMLInputElement.files fileInput)
          for_ maybeFiles
            (FileList.items >>> map File.name >>> setFileList)
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
