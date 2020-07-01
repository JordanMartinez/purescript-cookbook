module CardsHalogen.Main where

import Prelude

import CSS (fontSize, em)
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Class (class MonadEffect)
import Effect.Random (randomInt)
import Halogen (liftEffect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.CSS as HC
import Halogen.Hooks as Hooks
import Halogen.VDom.Driver (runUI)

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
  card /\ cardIdx <- Hooks.useState Three
  Hooks.pure $
    HH.div_
    [ HH.button
      [ HE.onClick \_ -> Just do
          -- Elm uses a uniform generator
          -- PureScript doesn't have an out-of-box version of that,
          -- so we'll just use a random value.
        i <- liftEffect $ randomInt 1 13
        Hooks.put cardIdx $ intToCard i
      ]
      [ HH.text "Draw" ]
    , HH.div
      [ HC.style do
        fontSize $ em 12.0
      ]
      [ HH.text $ renderCard card ]
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

renderCard :: Card -> String
renderCard = case _ of
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
