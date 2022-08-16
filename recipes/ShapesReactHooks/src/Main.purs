module ShapesReactHooks.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception (throw)
import React.Basic.DOM (text)
import React.Basic.DOM.Client (createRoot, renderRoot)
import React.Basic.DOM.SVG as R
import React.Basic.Hooks (Component, component)
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
mkApp =
  component "ShapesComponent" \_ -> React.do
    pure
      $ R.svg
          { viewBox: "0 0 400 400"
          , width: "400"
          , height: "400"
          , children:
              [ R.circle
                  { cx: "50"
                  , cy: "50"
                  , r: "40"
                  , fill: "red"
                  , stroke: "black"
                  , strokeWidth: "3"
                  }
              , R.rect
                  { x: "100"
                  , y: "10"
                  , width: "40"
                  , height: "40"
                  , fill: "green"
                  , stroke: "black"
                  , strokeWidth: "2"
                  }
              , R.line
                  { x1: "20"
                  , y1: "200"
                  , x2: "200"
                  , y2: "20"
                  , stroke: "blue"
                  , strokeWidth: "10"
                  , strokeLinecap: "round"
                  }
              , R.polyline
                  { points: "200,40 240,40 240,80 280,80 280,120 320,120 320,160"
                  , fill: "none"
                  , stroke: "red"
                  , strokeWidth: "4"
                  , strokeDasharray: "20,2"
                  }
              , R.text
                  { x: "130"
                  , y: "130"
                  , fill: "black"
                  , textAnchor: "middle"
                  , dominantBaseline: "central"
                  , transform: "rotate(-45 130,130)"
                  , children:
                      [ text "Welcome to Shapes Club"
                      ]
                  }
              ]
          }
