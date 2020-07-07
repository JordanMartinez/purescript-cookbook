module PositionsHalogenHooks.Main where

import Prelude hiding (top)

import CSS (position, absolute, top, left, px)
import Data.Int (toNumber)
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Class (class MonadEffect)
import Effect.Random (randomInt)
import Halogen (liftEffect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.CSS as HC
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
  pos /\ posIdx <- Hooks.useState { x: 100, y: 100 }
  Hooks.pure $
    HH.button
      [ HC.style do
          position absolute
          top $ px $ toNumber pos.x
          left $ px $ toNumber pos.y
      , HE.onClick \_ -> Just do
          newPosition <- liftEffect do
            newX <- randomInt 50 350
            newY <- randomInt 50 350
            pure $ { x: newX, y: newY }
          Hooks.put posIdx newPosition
      ]
      [ HH.text "Click me!" ]
