module ReadPrintFileContentsConcur.Main where

import Prelude

import Concur.Core (Widget)
import Concur.React (HTML)
import Concur.React.DOM as D
import Concur.React.Props as P
import Concur.React.Run (runWidgetInDom)
import Data.Maybe (Maybe(..), maybe)
import Effect (Effect)
import Effect.Aff.Class (liftAff)
import Effect.Class (liftEffect)
import React.SyntheticEvent (NativeEventTarget, SyntheticEvent_, target)
import Unsafe.Coerce (unsafeCoerce)
import Web.Event.Internal.Types (EventTarget)
import Web.File.File (toBlob)
import Web.File.FileList (FileList, item)
import Web.File.FileReader.Aff (readAsText)
import Web.HTML.HTMLInputElement (files, fromEventTarget)

fileList :: EventTarget -> Effect (Maybe FileList)
fileList tar = case fromEventTarget tar of
  Just elem -> files elem
  _ -> pure Nothing

getContent
  :: forall t
   . Widget HTML
       ( SyntheticEvent_
           ( target :: NativeEventTarget
           | t
           )
       )
  -> Widget HTML String
getContent ev = do
  nativeTarget <- liftEffect =<< target <$> ev
  mfs <- liftEffect $ fileList $ unsafeCoerce nativeTarget
  liftAff
    $ maybe (pure "")
        readAsText
    $ (Just <<< toBlob) =<< item 0 =<< mfs

textFileToScreenWidget :: Widget HTML String
textFileToScreenWidget = do
  content <- getContent $ D.input
    [ P._type "file"
    , P.onChange
    ]
  D.pre' [ D.text content ]

main :: Effect Unit
main = do
  runWidgetInDom "app" textFileToScreenWidget

