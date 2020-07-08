module ImagePreviewsHalogenHooks.Main where

import Prelude hiding (top)

import CSS (alignItems, backgroundImage, backgroundPosition, backgroundRepeat, backgroundSize, border, borderRadius, column, contain, dashed, display, displayNone, flex, flexDirection, gray, height, justifyContent, margin, noRepeat, padding, placed, purple, px, sideCenter, solid, url, width)
import CSS as CSS
import CSS.Common (center)
import DOM.HTML.Indexed.InputAcceptType (mediaType)
import DOM.HTML.Indexed.InputType (InputType(..))
import Data.Array (snoc)
import Data.Maybe (Maybe(..), maybe)
import Data.MediaType (MediaType(..))
import Data.Traversable (for, sequence_)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Ref (Ref)
import Effect.Ref as Ref
import Halogen (ClassName(..))
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.CSS as HC
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.Hooks (HookM, StateToken)
import Halogen.Hooks as Hooks
import Halogen.Hooks.Extra.Actions.Events (preventDefault)
import Halogen.VDom.Driver (runUI)
import Web.File.File (File, toBlob)
import Web.File.FileList as FileList
import Web.File.Url (createObjectURL, revokeObjectURL)
import Web.HTML.Event.DataTransfer as DataTransfer
import Web.HTML.Event.DragEvent (dataTransfer)
import Web.HTML.Event.DragEvent as DragEvent

main :: Effect Unit
main =
  HA.runHalogenAff do
    body <- HA.awaitBody
    void $ runUI hookComponent unit body

hookComponent
  :: forall unusedQuery unusedInput unusedOutput anyMonad
   . MonadEffect anyMonad
  => H.Component HH.HTML unusedQuery unusedInput unusedOutput anyMonad
hookComponent = Hooks.component \_ _ -> Hooks.do
  hover /\ hoverIdx <- Hooks.useState false
  _ /\ ref <- Hooks.useRef []
  urls /\ urlsIdx <- Hooks.useState []
  Hooks.pure $
    HH.div
    [ HC.style do
        border dashed (px 6.0) $ if hover then purple else CSS.fromInt 0xcccccc
        borderRadius (px 20.0) (px 20.0) (px 20.0) (px 20.0)
        width (px 480.0)
        height (px 100.0)
        margin (px 100.0) (px 100.0) (px 100.0) (px 100.0)
        padding (px 40.0) (px 40.0) (px 40.0) (px 40.0)
        display flex
        flexDirection column
        justifyContent center
        alignItems center
    , HE.onDragEnter \e -> Just do
        preventDefault DragEvent.toEvent e
        Hooks.put hoverIdx true
    , HE.onDragOver \e -> Just do
        preventDefault DragEvent.toEvent e
        Hooks.put hoverIdx true
    , HE.onDragLeave \e -> Just do
        preventDefault DragEvent.toEvent e
        Hooks.put hoverIdx false
    , HE.onDrop \e -> Just do
        preventDefault DragEvent.toEvent e
        let
          mbFileList = DataTransfer.files $ dataTransfer e
          fileArray = maybe [] FileList.items mbFileList
        putFileUrls ref urlsIdx fileArray
    ]
    -- Note: Elm uses a button that, when clicked, will do the following:
    -- 1. create an input element
    -- 2. add it to the DOM
    -- 3. create a mouse event
    -- 4. dispatch the mouse event to the input element
    -- 5. (implication) file dialogue appears
    -- 6. user selects a file
    -- 7. input event handler runs a callback using user's selected file
    -- 8. input element is removed from DOM
    --
    -- The approach used below is based on this SO answer:
    -- https://stackoverflow.com/a/47094148
    [ HH.label
      [ HP.for "file-input" ]
      [ HH.div
        -- simulate button-like appearance
        [ HC.style do
            margin (px 4.0) (px 4.0) (px 4.0) (px 4.0)
            border solid (px 2.0) gray
            borderRadius (px 20.0) (px 20.0) (px 20.0) (px 20.0)
            padding (px 20.0) (px 20.0) (px 20.0) (px 20.0)
        , HP.class_ $ ClassName "otherCssNotInPurescript-Css"
        ]
        [ HH.text "Upload images" ]
      ]
    , HH.input
        [ HP.id_ "file-input"
        , HC.style $ display displayNone
        , HP.type_ InputFile
        , HP.accept $ mediaType $ MediaType "images/*"
        , HP.multiple true
        , HE.onFileUpload \fileArray -> Just do
            putFileUrls ref urlsIdx fileArray
        ]
    , HH.div
          [ HC.style do
              display flex
              alignItems center
              height (px 60.0)
              padding (px 20.0) (px 20.0) (px 20.0) (px 20.0)
          ]
          (urls <#> \fileUrl ->
            HH.div
              [ HC.style do
                  width (px 60.0)
                  height (px 60.0)
                  backgroundImage $ url fileUrl
                  backgroundPosition $ placed sideCenter sideCenter
                  backgroundRepeat noRepeat
                  backgroundSize contain
              ]
              []
          )
    ]
  where
    putFileUrls
      :: Ref (Array (Effect Unit))
      -> StateToken (Array String)
      -> Array File
      -> HookM anyMonad Unit
    putFileUrls arrayRef idx files = do
      -- revoke all prior object urls
      -- by running their effects and ignoring the result
      liftEffect do
        arrayOfRemovePriorObjectUrls <- Ref.read arrayRef
        sequence_ arrayOfRemovePriorObjectUrls

      arrayOfUrls <- for files \file -> do
        liftEffect do
          -- create the object url
          urlString <- createObjectURL (toBlob file)

          -- create an effect that, when run, will revoke the url
          -- and clean up memory
          let
            revokeUrl :: Effect Unit
            revokeUrl = revokeObjectURL urlString
          -- add that effect to our mutable reference
          Ref.modify_ (\arr -> arr `snoc` revokeUrl) arrayRef

          -- now return the original url
          pure urlString
      Hooks.put idx arrayOfUrls
