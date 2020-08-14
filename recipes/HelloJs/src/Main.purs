module HelloJs.Main where

import Prelude
import Data.Maybe (maybe)
import Effect (Effect)
import Effect.Exception (throw)
import Web.DOM.Node (setTextContent)
import Web.HTML (window)
import Web.HTML.HTMLDocument as HTMLDocument
import Web.HTML.HTMLElement as HTMLElement
import Web.HTML.Window (document)

main :: Effect Unit
main = do
  doc <- document =<< window
  body <- maybe (throw "Could not find body element") pure =<< HTMLDocument.body doc
  let
    bodyNode = HTMLElement.toNode body
  setTextContent "Hello!" bodyNode
