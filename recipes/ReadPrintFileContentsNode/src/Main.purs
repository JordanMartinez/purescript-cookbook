module ReadPrintFileContentsNode.Main where

import Prelude

import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Node.Encoding (Encoding(..))
import Node.FS.Aff (readTextFile)

main :: Effect Unit
main = launchAff_ do
  fileContents <- readTextFile UTF8 "./LICENSE"
  liftEffect $ log fileContents
