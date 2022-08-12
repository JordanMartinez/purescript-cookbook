module TimeReactHooks.Main where

import Prelude

import Data.Array (intercalate)
import Data.Int (floor)
import Data.JSDate (JSDate)
import Data.JSDate as JSDate
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype)
import Effect (Effect)
import Effect.Exception (throw)
import Effect.Timer (clearInterval, setInterval)
import React.Basic.DOM (render)
import React.Basic.DOM as R
import React.Basic.Hooks (Component, Hook, UseEffect, UseState, coerceHook, component, useEffectOnce, useState', (/\))
import React.Basic.Hooks as React
import Web.HTML (window)
import Web.HTML.HTMLDocument (body)
import Web.HTML.HTMLElement (toElement)
import Web.HTML.Window (document)

type Time = { hours :: Int, minutes :: Int, seconds :: Int }

main :: Effect Unit
main = do
  body <- body =<< document =<< window
  case body of
    Nothing -> throw "Could not find body."
    Just b -> do
      time <- mkTime
      render (time {}) (toElement b)

mkTime :: Component {}
mkTime = do
  now <- JSDate.now >>= getTime
  component "Time" \_ -> React.do
    { hours, minutes, seconds } <- useCurrentTime now
    pure
      $ R.h1_
          [ R.text
              $ intercalate ":"
                  [ show hours
                  , show minutes
                  , show seconds
                  ]
          ]

newtype UseCurrentTime hooks = UseCurrentTime (UseEffect Unit (UseState Time hooks))

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
  hours <- floor <$> JSDate.getHours date
  minutes <- floor <$> JSDate.getMinutes date
  seconds <- floor <$> JSDate.getSeconds date
  in { hours, minutes, seconds }
