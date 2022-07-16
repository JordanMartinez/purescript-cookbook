module ClockReactHooks.Main where

import Prelude

import Data.JSDate (JSDate)
import Data.JSDate as JSDate
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype)
import Data.Number (cos, sin, tau)
import Effect (Effect)
import Effect.Exception (throw)
import Effect.Timer (clearInterval, setInterval)
import React.Basic.DOM (render)
import React.Basic.DOM.SVG as SVG
import React.Basic.Hooks (Component, Hook, JSX, UseEffect, UseState, coerceHook, component, useEffectOnce, useState', (/\))
import React.Basic.Hooks as React
import Web.HTML (window)
import Web.HTML.HTMLDocument (body)
import Web.HTML.HTMLElement (toElement)
import Web.HTML.Window (document)

type Time
  = { hours :: Number, minutes :: Number, seconds :: Number }

main :: Effect Unit
main = do
  body <- body =<< document =<< window
  case body of
    Nothing -> throw "Could not find body."
    Just b -> do
      clock <- mkClock
      render (clock {}) (toElement b)

mkClock :: Component {}
mkClock = do
  now <- JSDate.now >>= getTime
  component "Clock" \_ -> React.do
    { hours, minutes, seconds } <- useCurrentTime now
    pure
      $ SVG.svg
          { viewBox: "0 0 400 400"
          , width: "400"
          , height: "400"
          , children:
              [ SVG.circle { cx: "200", cy: "200", r: "120", fill: "#1293D8" }
              , hand 6 60.0 (hours / 12.0)
              , hand 6 90.0 (minutes / 60.0)
              , hand 3 90.0 (seconds / 60.0)
              ]
          }

hand :: Int -> Number -> Number -> JSX
hand width length turns =
  let
    t = tau * (turns - 0.25)

    x = 200.0 + length * cos t

    y = 200.0 + length * sin t
  in
    SVG.line
      { x1: "200"
      , y1: "200"
      , x2: show x
      , y2: show y
      , stroke: "white"
      , strokeWidth: show width
      , strokeLinecap: "round"
      }

newtype UseCurrentTime hooks
  = UseCurrentTime (UseEffect Unit (UseState Time hooks))

derive instance ntUseCurrentTime :: Newtype (UseCurrentTime hooks) _

useCurrentTime :: Time -> Hook UseCurrentTime Time
useCurrentTime initialTime =
  coerceHook React.do
    currentTime /\ setCurrentTime <- useState' initialTime
    useEffectOnce do
      intervalId <- setInterval 1000 (JSDate.now >>= getTime >>= setCurrentTime)
      pure (clearInterval intervalId)
    pure currentTime

getTime :: JSDate -> Effect Time
getTime date = ado
  hours <- JSDate.getHours date
  minutes <- JSDate.getMinutes date
  seconds <- JSDate.getSeconds date
  in { hours, minutes, seconds }
