module CardsReactHooks.Main where

import Prelude
import Data.Array.NonEmpty (cons')
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception (throw)
import React.Basic.DOM (css, render)
import React.Basic.DOM as R
import React.Basic.Events (handler_)
import React.Basic.Hooks (Component, component, useState, (/\))
import React.Basic.Hooks as React
import Test.QuickCheck (mkSeed)
import Test.QuickCheck.Gen (Gen, elements, runGen)
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
      cardsComponent <- mkCardsComponent
      render (cardsComponent {}) (toElement b)

mkCardsComponent :: Component {}
mkCardsComponent = do
  let
    initialGenState = { newSeed: mkSeed 3, size: 1 }
  component "Cards" \_ -> React.do
    -- "Card state" is a tuple of the card and generator state.
    -- We don't need the actual generator state for rendering, so we're ignoring it with `_`.
    (card /\ _) /\ setCardState <- useState (runGen cardGenerator initialGenState)
    let
      onClick =
        handler_ do
          -- Modify the card generator state by re-running the generator.
          -- We don't need the card value for this update function, so it is ignored with `_`.
          setCardState \(_ /\ genState) -> runGen cardGenerator genState
    pure
      $ R.div_
          [ R.button { onClick, children: [ R.text "Draw" ] }
          , R.div { style: css { fontSize: "12em" }, children: [ R.text (viewCard card) ] }
          ]

data Card
  = Ace
  | Two
  | Three
  | Four
  | Five
  | Six
  | Seven
  | Eight
  | Nine
  | Ten
  | Jack
  | Queen
  | King

cardGenerator :: Gen Card
cardGenerator =
  elements
    $ cons' Ace
        [ Two
        , Three
        , Four
        , Five
        , Six
        , Seven
        , Eight
        , Nine
        , Ten
        , Jack
        , Queen
        , King
        ]

viewCard :: Card -> String
viewCard = case _ of
  Ace -> "🂡"
  Two -> "🂢"
  Three -> "🂣"
  Four -> "🂤"
  Five -> "🂥"
  Six -> "🂦"
  Seven -> "🂧"
  Eight -> "🂨"
  Nine -> "🂩"
  Ten -> "🂪"
  Jack -> "🂫"
  Queen -> "🂭"
  King -> "🂮"
