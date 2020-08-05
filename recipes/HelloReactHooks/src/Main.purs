module HelloReactHooks.Main where

import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception (throw)
import React.Basic.DOM (render)
import React.Basic.DOM as R
import React.Basic.Hooks (Component, component)
import Web.HTML (window)
import Web.HTML.HTMLDocument (body)
import Web.HTML.HTMLElement (toElement)
import Web.HTML.Window (document)

main :: Effect Unit
main = do
  body <- body =<< document =<< window
  case body of
    Nothing -> throw "Could not find body."
    Just b -> do
      helloComponent <- mkHelloComponent
      render (helloComponent {}) (toElement b)

mkHelloComponent :: Component {}
mkHelloComponent = do
  component "HelloComponent" \_ -> React.do
    pure (R.text "Hello!")
