module WriteFileNode.Main where

import Prelude

import Effect (Effect)
import Effect.Aff (launchAff_)
import Node.Encoding (Encoding(..))
import Node.FS.Aff (writeTextFile)

main :: Effect Unit
main = launchAff_ do
  writeTextFile UTF8 "./recipes/WriteFileNode/example.txt" "File content."
