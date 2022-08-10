module ShapesHalogenHooks.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.Hooks as Hooks
import Halogen.Svg.Attributes
  ( Baseline(Central)
  , Color(RGB)
  , CommandPositionReference(Abs)
  , TextAnchor(AnchorMiddle)
  , Transform(Rotate)
  , cx
  , cy
  , d
  , dominantBaseline
  , fill
  , height
  , l
  , m
  , r
  , stroke
  , strokeWidth
  , textAnchor
  , transform
  , viewBox
  , width
  , x
  , x1
  , x2
  , y
  , y1
  , y2
  )
import Halogen.Svg.Elements (circle, line, path, rect, svg, text)
import Halogen.VDom.Driver (runUI)

{- We import a lot of functions from Halogen.Svg.Attributes which makes the SVG
   code below cleaner. You may prefer to import with
      `import Halogen.Svg.Attributes as SA`
   and then prefix all calls with `SA.`
-}

main :: Effect Unit
main =
  HA.runHalogenAff do
    body <- HA.awaitBody
    void $ runUI hookComponent Nothing body

hookComponent
  :: forall unusedQuery unusedInput unusedOutput anyMonad
   . H.Component unusedQuery unusedInput unusedOutput anyMonad
hookComponent =
  Hooks.component \_ _ ->
    Hooks.pure
      $ svg
          [ viewBox 0.0 0.0 400.0 400.0
          , width 400.0
          , height 400.0
          ]
          [ circle
              [ cx 50.0
              , cy 50.0
              , r 40.0
              , fill $ RGB 255 0 0
              , stroke $ RGB 0 0 0
              ]
          , rect
              [ x 100.0
              , y 10.0
              , width 40.0
              , height 40.0
              , fill $ RGB 0 120 0
              , stroke $ RGB 0 0 0
              ]
          , line
              [ x1 20.0
              , y1 200.0
              , x2 200.0
              , y2 20.0
              , stroke $ RGB 0 0 255
              , strokeWidth 10.0
              ]
          , path
              [ d
                  [ m Abs 200.0 40.0
                  , l Abs 240.0 40.0
                  , l Abs 240.0 80.0
                  , l Abs 280.0 80.0
                  , l Abs 280.0 120.0
                  , l Abs 320.0 120.0
                  , l Abs 320.0 160.0
                  ]
              , stroke $ RGB 255 0 0
              ]
          , text
              [ x 130.0
              , y 130.0
              , fill $ RGB 0 0 0
              , textAnchor AnchorMiddle
              , dominantBaseline Central
              , transform $ [ Rotate (-45.0) 130.0 130.0 ]
              ]
              [ HH.text "Welcome to Shapes Club"
              ]
          ]
