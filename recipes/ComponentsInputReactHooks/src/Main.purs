module ComponentsInputReactHooks.Main where

import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception (throw)
import Effect.Unsafe (unsafePerformEffect)
import React.Basic.DOM (render)
import React.Basic.DOM as R
import React.Basic.Events (handler_)
import React.Basic.Hooks
  ( Component
  , Render
  , UseEffect
  , UseRef
  , component
  , readRef
  , useEffectAlways
  , useRef
  , useState
  , writeRef
  , (/\)
  )
import React.Basic.Hooks as React
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
      container <- mkContainer
      render (container unit) (toElement b)

mkContainer :: Component Unit
mkContainer = do
  display <- mkDisplay
  component "Container" \_ -> React.do
    parentRenders <- useRenderCount
    state /\ setState <- useState 0
    pure
      $ R.div_
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
              [ R.text ("Parent has been rendered " <> show parentRenders <> " time(s)") ]
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
  let
    renders = unsafePerformEffect (readRef rendersRef)
  pure renders
