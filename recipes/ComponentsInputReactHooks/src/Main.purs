module ComponentsInputReactHooks.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception (throw)
import Effect.Unsafe (unsafePerformEffect)
import React.Basic.DOM as R
import React.Basic.DOM.Client (createRoot, renderRoot)
import React.Basic.Events (handler_)
import React.Basic.Hooks (Component, Render, UseEffect, UseRef, component, readRef, useEffectAlways, useRef, useState, writeRef, (/\))
import React.Basic.Hooks as React
import Web.DOM.NonElementParentNode (getElementById)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.Window (document)

main :: Effect Unit
main = do
  doc <- document =<< window
  root <- getElementById "root" $ toNonElementParentNode doc
  case root of
    Nothing -> throw "Could not find root."
    Just container -> do
      reactRoot <- createRoot container
      app <- mkApp
      renderRoot reactRoot (app {})

mkApp :: Component {}
mkApp = do
  display <- mkDisplay
  component "Container" \_ -> React.do
    parentRenders <- useRenderCount
    state /\ setState <- useState 0
    pure $ R.div_
      [ R.ul_
          [ display state
          , display (state * 2)
          , display (state * 3)
          , display (state * 10)
          , display (state * state)
          ]
      , R.button
          { onClick: handler_ (setState (_ + 1))
          , children: [ R.text "+1" ]
          }
      , R.button
          { onClick: handler_ (setState (_ - 1))
          , children: [ R.text "-1" ]
          }
      , R.p_
          [ R.text
              ( "Parent has been rendered "
                  <> show parentRenders
                  <> " time(s)"
              )
          ]
      ]

mkDisplay :: Component Int
mkDisplay =
  component "Display" \n ->
    pure
      $ R.div_
          [ R.text "My input value is: "
          , R.strong_ [ R.text (show n) ]
          ]

useRenderCount :: forall a. Render a (UseEffect Unit (UseRef Int a)) Int
useRenderCount = React.do
  rendersRef <- useRef 1
  useEffectAlways do
    renders <- readRef rendersRef
    writeRef rendersRef (renders + 1)
    pure mempty
  let renders = unsafePerformEffect (readRef rendersRef)
  pure renders
