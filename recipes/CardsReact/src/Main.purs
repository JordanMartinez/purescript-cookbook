module CardsReact.Main where

import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception (throw)
import Effect.Random (randomInt)
import React.Basic.DOM (css, render)
import React.Basic.DOM as R
import React.Basic.Events (handler_)
import React.Basic.Hooks (Component, component, useState', (/\))
import React.Basic.Hooks as React
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
    card /\ setCard <- useState' Three
    let
      onClick =
        handler_ do
          n <- randomInt 1 13
          setCard (intToCard n)
    pure
      $ R.div_
          [ R.button { onClick, children: [ R.text "Draw" ] }
          , R.div { style: css { fontSize: "12em" }, children: [ R.text (viewCard card) ] }
          ]

intToCard :: Int -> Card
intToCard = case _ of
  1 -> Ace
  2 -> Two
  3 -> Three
  4 -> Four
  5 -> Five
  6 -> Six
  7 -> Seven
  8 -> Eight
  9 -> Nine
  10 -> Ten
  11 -> Jack
  12 -> Queen
  _ -> King

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
