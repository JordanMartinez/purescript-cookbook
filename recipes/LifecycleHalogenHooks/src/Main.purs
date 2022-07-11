module LifecycleHalogenHooks.Main where

import Prelude

import Data.Array (filter, reverse, snoc)
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Class (class MonadEffect)
import Effect.Console (log)
import Halogen (liftEffect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Elements.Keyed as HHK
import Halogen.HTML.Events as HE
import Halogen.Hooks as Hooks
import Halogen.VDom.Driver (runUI)
import Type.Proxy (Proxy(..))

main :: Effect Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody
  runUI rootComponent unit body

rootComponent
  :: forall unusedInput unusedQuery unusedOutput anyMonad
   . MonadEffect anyMonad
  => H.Component unusedQuery unusedInput unusedOutput anyMonad
rootComponent = Hooks.component \_rec _ -> Hooks.do
  state /\ stateIdx <- Hooks.useState { currentId: 0, slots: []}
  Hooks.useLifecycleEffect do
    liftEffect $ log "Initialize Root"
    pure Nothing

  Hooks.pure $
    HH.div_
      [ HH.button
          [ HE.onClick \_ -> do
            Hooks.modify_ stateIdx \s ->
              { currentId: s.currentId + 1
              , slots: snoc s.slots s.currentId
              }
          ]
          [ HH.text "Add" ]
      , HH.button
          [ HE.onClick \_ -> do
              Hooks.modify_ stateIdx \st -> st { slots = reverse st.slots }
          ]
          [ HH.text "Reverse" ]
      , HHK.ul_ $ flip map state.slots \sid ->
          Tuple (show sid) $
            HH.li_
              [ HH.button
                  [ HE.onClick \_ -> do
                      Hooks.modify_ stateIdx \st ->
                        st { slots = filter (not <<< eq sid) st.slots }
                  ]
                  [ HH.text "Remove" ]
              , HH.slot _child sid (childComponent sid) unit (listen sid)
              ]
      ]
  where
    _child = Proxy :: Proxy "child"

    listen :: Int -> Message -> _
    listen i m = do
      let
        msg = case m of
          Initialized -> "Heard Initialized from child" <> show i
          Finalized -> "Heard Finalized from child" <> show i
          Reported msg' -> "Re-reporting from child" <> show i <> ": " <> msg'
      liftEffect $ log ("Root >>> " <> msg)

data Message
  = Initialized
  | Finalized
  | Reported String

childComponent
  :: forall unusedInput unusedQuery anyMonad
   . MonadEffect anyMonad
  => Int
  -> H.Component unusedQuery unusedInput Message anyMonad
childComponent id = Hooks.component \rec _ -> Hooks.do
  Hooks.useLifecycleEffect do
    liftEffect $ log ("Initialize Child " <> show id)
    Hooks.raise rec.outputToken Initialized
    pure $ Just do
      liftEffect $ log ("Finalize Child " <> show id)
      Hooks.raise rec.outputToken Finalized

  Hooks.pure $
    HH.div_
      [ HH.text ("Child " <> show id)
      , HH.ul_
        [ HH.slot _cell 0 (cell 0) unit (listen rec.outputToken 0)
        , HH.slot _cell 1 (cell 1) unit (listen rec.outputToken 1)
        , HH.slot _cell 2 (cell 2) unit (listen rec.outputToken 2)
        ]
      ]
  where
    _cell = Proxy :: Proxy "cell"

    listen :: _ -> Int -> Message -> _
    listen outputToken i m = do
      let
        msg = case m of
          Initialized -> "Heard Initialized from cell" <> show i
          Finalized -> "Heard Finalized from cell" <> show i
          Reported msg' -> "Re-reporting from cell" <> show i <> ": " <> msg'
      liftEffect $ log $ "Child " <> show i <> " >>> " <> msg
      Hooks.raise outputToken (Reported msg)

cell
  :: forall unusedInput unusedQuery anyMonad
   . MonadEffect anyMonad
  => Int
  -> H.Component unusedQuery unusedInput Message anyMonad
cell id = Hooks.component \rec _ -> Hooks.do
  Hooks.useLifecycleEffect do
    liftEffect $ log ("Initialize Cell " <> show id)
    Hooks.raise rec.outputToken Initialized
    pure $ Just do
      liftEffect $ log ("Finalize Cell " <> show id)
      Hooks.raise rec.outputToken Finalized

  Hooks.pure $
    HH.li_ [ HH.text ("Cell " <> show id) ]
