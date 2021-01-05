module CapabilityPatternWithCheckedExceptionsNode.Main where

import Prelude

import App.Application (program)
import App.ProductionExcV as AppExcVM
import Effect (Effect)
import Effect.Aff (launchAff_)

-- | See CapabilityPatternNode for other, simpler, examples of this pattern

-- | Layer 0 - Running the `program` in this context
main :: Effect Unit
main = launchAff_ do
  result <- AppExcVM.runApp program { url: "http://www.purescript.org"}
  pure unit
