module DragAndDropHalogenHooks.Main where

import Prelude hiding (top)

import CSS (alignItems, backgroundColor, border, borderRadius, color, column, dashed, display, displayNone, flex, flexDirection, gray, height, justifyContent, lightblue, margin, padding, purple, px, solid, width)
import CSS as CSS
import CSS.Common (center)
import DOM.HTML.Indexed.InputAcceptType (mediaType)
import DOM.HTML.Indexed.InputType (InputType(..))
import Data.Interpolate (i)
import Data.Maybe (Maybe(..), maybe)
import Data.MediaType (MediaType(..))
import Data.String (toUpper)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Class (class MonadEffect)
import Halogen (ClassName(..))
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.CSS as HC
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.Hooks as Hooks
import Halogen.Hooks.Extra.Actions.Events (preventDefault)
import Halogen.VDom.Driver (runUI)
import Web.File.File as File
import Web.File.FileList as FileList
import Web.HTML.Event.DataTransfer as DataTransfer
import Web.HTML.Event.DragEvent (dataTransfer)
import Web.HTML.Event.DragEvent as DragEvent

main :: Effect Unit
main =
  HA.runHalogenAff do
    body <- HA.awaitBody
    void $ runUI hookComponent Nothing body

hookComponent
  :: forall unusedQuery unusedInput unusedOutput anyMonad
   . MonadEffect anyMonad
  => H.Component HH.HTML unusedQuery unusedInput unusedOutput anyMonad
hookComponent = Hooks.component \_ _ -> Hooks.do
  hover /\ hoverIdx <- Hooks.useState false
  files /\ filesIdx <- Hooks.useState []
  Hooks.pure $
    HH.div
    [ HC.style do
        border dashed (px 6.0) $ if hover then purple else CSS.fromInt 0xcccccc
        borderRadius (px 20.0) (px 20.0) (px 20.0) (px 20.0)
        width (px 480.0)
        height (px 100.0)
        margin (px 100.0) (px 100.0) (px 100.0) (px 100.0)
        padding (px 20.0) (px 20.0) (px 20.0) (px 20.0)
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
        Hooks.put filesIdx fileArray
        Hooks.put hoverIdx false
    ]
    [ HH.label
      -- simulate button-like appearance
      [ HC.style do
          margin (px 4.0) (px 4.0) (px 4.0) (px 4.0)
          border solid (px 2.0) gray
          borderRadius (px 20.0) (px 20.0) (px 20.0) (px 20.0)
          padding (px 20.0) (px 20.0) (px 20.0) (px 20.0)
          backgroundColor lightblue
      , HP.class_ $ ClassName "otherCssNotInPurescript-Css"
      ]
      [ HH.text "Upload images"
      , HH.input
          [ HC.style $ display displayNone
          , HP.type_ InputFile
          , HP.multiple true
          , HP.accept $ mediaType $ MediaType "image/*"
          , HE.onFileUpload \fileArray -> Just $ Hooks.put filesIdx fileArray
          ]
      ]
    , HH.span
      [ HC.style $ color $ CSS.fromInt 0xcccccc ]
      [ HH.text $ i "{ files = "(show $ map File.name files)", hover = "(toUpper $ show hover)" }" ]
    ]
{-
The easiest way to create a file input dialog is with the input element:

  HH.input [ HP.type_ InputFile ]

However, this interface cannot be styled like a regular button - A common problem:
  https://stackoverflow.com/q/5813344
  https://stackoverflow.com/q/21842274
  https://stackoverflow.com/q/2048026

The workaround used in this recipe is to put the `input` within a `label`
and style the label to appear as a button. Unfortunately, we can't just reuse
default button styling.

Elm's workaround for custom file input styling is to use its runtime to
let users call File.Select.files on button click, which performs the following:
  1. create an input element
  2. add it to the DOM
  3. create a mouse event
  4. dispatch the mouse event to the input element
  5. (implication) file dialogue appears
  6. user selects a file
  7. input event handler runs a callback using user's selected file
  8. input element is removed from DOM
-}