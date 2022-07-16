module HelloConcur.Main where

import Prelude
import Effect (Effect)
import Concur.React.Run (runWidgetInDom)
import Concur.React.DOM (text)

main :: Effect Unit
main = do
  runWidgetInDom "app" (text "Hello!")
