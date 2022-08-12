module HelloConcur.Main where

import Prelude

import Concur.React.DOM (text)
import Concur.React.Run (runWidgetInDom)
import Effect (Effect)

main :: Effect Unit
main = do
  runWidgetInDom "app" (text "Hello!")
