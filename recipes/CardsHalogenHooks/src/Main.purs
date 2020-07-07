module CardsHalogenHooks.Main where

import Prelude

import CSS (fontSize, em)
import Data.Maybe (Maybe(..))
import Data.NonEmpty ((:|))
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Class (class MonadEffect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.CSS as HC
import Halogen.HTML.Events as HE
import Halogen.Hooks as Hooks
import Halogen.VDom.Driver (runUI)
import Test.QuickCheck (mkSeed)
import Test.QuickCheck.Gen (Gen, elements, runGen)

main :: Effect Unit
main =
  HA.runHalogenAff do
    body <- HA.awaitBody
    void $ runUI hookComponent Nothing body

hookComponent
  :: forall unusedQuery unusedInput unusedOutput anyMonad
   . MonadEffect anyMonad
  => H.Component HH.HTML unusedQuery unusedInput unusedOutput anyMonad
hookComponent = Hooks.component \_ _ -> Hooks.do
  let
    initialGenState = { newSeed: mkSeed 3, size: 1 }
  -- "Card state" is a tuple of the card and generator state.
  -- We don't need the actual generator state for rendering, so we're ignoring it with `_`.
  (card /\ _) /\ cardStateIdx <- Hooks.useState (runGen cardGenerator initialGenState)
  Hooks.pure $
    HH.div_
    [ HH.button
      [ HE.onClick \_ -> Just do
        -- Modify the card generator state by re-running the generator.
        -- We don't need the card value for this update function, so it is ignored with `_`.
        Hooks.modify_ cardStateIdx \(_ /\ genState) -> runGen cardGenerator genState
      ]
      [ HH.text "Draw" ]
    , HH.div
      [ HC.style do
        fontSize $ em 12.0
      ]
      [ HH.text $ viewCard card ]
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
