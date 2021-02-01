module DragAndDropReactHooks.Main where

import Prelude
import Data.Foldable as Foldable
import Data.Maybe (Maybe(..))
import Data.Nullable as Nullable
import Effect (Effect)
import Effect.Exception as Exception
import React.Basic.DOM as R
import React.Basic.DOM.Events as DOM.Events
import React.Basic.Events (SyntheticEvent)
import React.Basic.Events as Events
import React.Basic.Hooks (Component, (/\))
import React.Basic.Hooks as React
import Unsafe.Coerce as Coerce
import Web.File.File as File
import Web.File.FileList as FileList
import Web.HTML as HTML
import Web.HTML.Event.DataTransfer as DataTransfer
import Web.HTML.Event.DragEvent (DragEvent)
import Web.HTML.Event.DragEvent as DragEvent
import Web.HTML.HTMLDocument as HTMLDocument
import Web.HTML.HTMLElement as HTMLElement
import Web.HTML.HTMLInputElement as HTMLInputElement
import Web.HTML.Window as Window

main :: Effect Unit
main = do
  maybeBody <- HTMLDocument.body =<< Window.document =<< HTML.window
  case maybeBody of
    Nothing -> Exception.throw "Could not find body."
    Just body -> do
      app <- mkApp
      R.render (app unit) (HTMLElement.toElement body)

mkApp :: Component Unit
mkApp = do
  React.component "App" \_ -> React.do
    hover /\ setHover <- React.useState' false
    files /\ setFiles <- React.useState []
    fileInputRef <- React.useRef Nullable.null
    let
      onButtonClick =
        Events.handler_ do
          maybeNode <- React.readRefMaybe fileInputRef
          Foldable.for_ (HTMLElement.fromNode =<< maybeNode) \htmlElement -> do
            HTMLElement.click htmlElement
    pure
      $ R.div
          { style:
              R.css
                { display: "flex"
                , flexDirection: "column"
                , alignItems: "center"
                , justifyContent: "center"
                , margin: "min(8rem, calc(50vh - 6rem)) auto"
                , borderRadius: "1rem"
                , inlineSize: "32rem"
                , blockSize: "12rem"
                , borderWidth: "0.4rem"
                , borderStyle: "dashed"
                , borderColor: if hover then "purple" else "lightgray"
                }
          , onDragEnter:
              Events.handler_ do
                setHover true
          , onDragLeave:
              Events.handler_ do
                setHover false
          , onDragOver:
              Events.handler DOM.Events.preventDefault \_ -> do
                setHover true
          , onDrop:
              Events.handler DOM.Events.preventDefault \e -> do
                setHover false
                let
                  maybeFileList = DataTransfer.files (DragEvent.dataTransfer (toDragEvent e))
                Foldable.for_ (FileList.items <$> maybeFileList) (setFiles <<< (<>))
          , children:
              [ R.button
                  { onClick: onButtonClick
                  , children: [ R.text "Upload Images" ]
                  }
              , R.input
                  { ref: fileInputRef
                  , hidden: true
                  , type: "file"
                  , multiple: true
                  , accept: "image/*"
                  , onChange:
                      Events.handler DOM.Events.currentTarget \target ->
                        Foldable.for_ (HTMLInputElement.fromEventTarget target) \fileInput -> do
                          maybeFileList <- HTMLInputElement.files fileInput
                          Foldable.for_ (FileList.items <$> maybeFileList) (setFiles <<< (<>))
                  }
              , R.pre
                  { style:
                      R.css
                        { color: "gray"
                        , whiteSpace: "break-spaces"
                        , textAlign: "center"
                        , overflow: "hidden"
                        , textOverflow: "ellipsis"
                        , inlineSize: "100%"
                        }
                  , children:
                      [ R.text (show { hover, files: File.name <$> files })
                      ]
                  }
              ]
          }

-- | We happen to know that we're dealing with a `DragEvent` where we're using this, but
-- | not every `SyntheticEvent` can be converted to a `DragEvent`, so this is a partial 
-- | function. A proper implementation of this would probably be typed 
-- |
-- | ```purs
-- | toDragEvent :: SyntheticEvent -> Maybe DragEvent
-- | ```
-- |
-- | and could use `Web.Internal.FFI.unsafeReadProtoTagged` to inspect the constructor
-- | of the event and verify that it is indeed a `DragEvent`.
toDragEvent :: SyntheticEvent -> DragEvent
toDragEvent = Coerce.unsafeCoerce
