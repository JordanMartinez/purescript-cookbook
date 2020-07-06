module CardsReactHooks.Main where

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
