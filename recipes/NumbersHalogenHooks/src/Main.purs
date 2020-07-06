module NumbersHalogenHooks.Main where

import Prelude

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
  roll /\ rollIdx <- Hooks.useState 1
  Hooks.pure $
    HH.div_
      [ HH.h1_ [ HH.text $ show roll ]
      , HH.button
        [ HE.onClick \_ -> Just do
            nextRoll <- liftEffect $ randomInt 1 6
            Hooks.put rollIdx nextRoll
        ]
        [ HH.text "Roll" ]
      ]
