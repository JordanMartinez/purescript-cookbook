module FindDomElementJs.Main where

import Prelude

import Data.Foldable (for_)
import Effect (Effect)
import Effect.Console (log)
import Web.DOM.NodeList as NodeList
import Web.DOM.ParentNode (QuerySelector(..), querySelector, querySelectorAll)
import Web.HTML (window)
import Web.HTML.HTMLDocument as Document
import Web.HTML.Window (document)

main :: Effect Unit
main = do
  -- get the document
  win <- window
  doc <- document win
  let docAsParent = Document.toParentNode doc

  mbDiv <- querySelector (QuerySelector ".class") docAsParent
  for_ mbDiv \e -> do
    log "Found `div` element with class"

  mbP <- querySelector (QuerySelector "#id") docAsParent
  for_ mbP \_ -> do
    log "Found `p` element with id"

  liNodeList <- querySelectorAll (QuerySelector ".classes") docAsParent
  numOfElems <- NodeList.length liNodeList
  if numOfElems == 4 then do
    log "Found all 4 list elements"
  else do
    log "Did not find all four list elements."

  mbThirdParInDivInDiv <- querySelector (QuerySelector "div.example div.third p.c") docAsParent
  for_ mbThirdParInDivInDiv \_ -> do
    log $ "Found third `p` in a `div` with `third` class in a `div` with \
          \`example` class."

  log $ "If any of the above queries did not find their corresponding element, \
        \please open an issue in the PureScript cookbook repository."
