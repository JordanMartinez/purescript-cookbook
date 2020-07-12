module TimeReactHooks.Main where

import Prelude
import Data.Array (intercalate)
import Data.Enum (fromEnum)
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype)
import Data.Time (Time)
import Data.Time as Time
import Effect (Effect)
import Effect.Exception (throw)
import Effect.Now (nowTime)
import Effect.Timer (clearInterval, setInterval)
import React.Basic.DOM (render)
import React.Basic.DOM as R
import React.Basic.Hooks (Component, Hook, UseEffect, UseState, coerceHook, component, useEffectOnce, useState', (/\))
import React.Basic.Hooks as React
import Web.DOM.NonElementParentNode (getElementById)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.Window (document)

main :: Effect Unit
main = do
  container <- getElementById "root" =<< map toNonElementParentNode (document =<< window)
  case container of
    Nothing -> throw "Root element not found."
    Just c -> do
      time <- mkTime
      render (time {}) c

mkTime :: Component {}
mkTime = do
  now <- nowTime
  component "Time" \_ -> React.do
    currentTime <- useCurrentTime now
    let
      hour = fromEnum (Time.hour currentTime)

      minute = fromEnum (Time.minute currentTime)

      second = fromEnum (Time.second currentTime)
    pure
      $ R.h1_
          [ R.text
              $ intercalate ":"
                  [ show hour
                  , show minute
                  , show second
                  ]
          ]

newtype UseCurrentTime hooks
  = UseCurrentTime (UseEffect Unit (UseState Time hooks))

derive instance ntUseCurrentTime :: Newtype (UseCurrentTime hooks) _

useCurrentTime :: Time -> Hook UseCurrentTime Time
useCurrentTime initialTime =
  coerceHook React.do
    currentTime /\ setCurrentTime <- useState' initialTime
    useEffectOnce do
      intervalId <- setInterval 1000 (nowTime >>= setCurrentTime)
      pure (clearInterval intervalId)
    pure currentTime
