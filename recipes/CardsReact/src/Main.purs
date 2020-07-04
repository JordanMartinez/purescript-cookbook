module CardsReact.Main where

import Prelude
import Data.Maybe (Maybe(..))
import Data.NonEmpty ((:|))
import Effect (Effect)
import Effect.Exception (throw)
import React.Basic.DOM (css, render)
import React.Basic.DOM as R
import React.Basic.Events (handler_)
import React.Basic.Hooks (Component, component, useState, (/\))
import React.Basic.Hooks as React
import Test.QuickCheck (mkSeed)
import Test.QuickCheck.Gen (Gen, elements, runGen)
import Web.DOM.NonElementParentNode (getElementById)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.Window (document)

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
    $ Ace
    :| [ Two
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

main :: Effect Unit
main = do
  container <- getElementById "root" =<< map toNonElementParentNode (document =<< window)
  case container of
    Nothing -> throw "Root element not found."
    Just c -> do
      cardsComponent <- mkCardsComponent
      render (cardsComponent {}) c

mkCardsComponent :: Component {}
mkCardsComponent = do
  component "Cards" \_ -> React.do
    let
      initialGenState = { newSeed: mkSeed 3, size: 1 }
    (card /\ _) /\ setCardState <- useState (runGen cardGenerator initialGenState)
    let
      onClick =
        handler_ do
          setCardState \(_ /\ genState) -> runGen cardGenerator genState
    pure
      $ R.div_
          [ R.button { onClick, children: [ R.text "Draw" ] }
          , R.div { style: css { fontSize: "12em" }, children: [ R.text (viewCard card) ] }
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
