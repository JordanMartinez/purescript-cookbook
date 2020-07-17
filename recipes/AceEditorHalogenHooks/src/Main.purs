module AceEditorHalogenHooks.Main where

import Prelude

import Ace (Editor)
import Ace as Ace
import Ace.EditSession as Session
import Ace.Editor as Editor
import Data.Foldable (traverse_)
import Data.Maybe (Maybe(..))
import Data.Symbol (SProxy(..))
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Aff.Class (class MonadAff)
import Halogen (liftEffect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.Hooks as Hooks
import Halogen.Query.EventSource as ES
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main =
  HA.runHalogenAff do
    body <- HA.awaitBody
    void $ runUI containerComponent unit body

_ace = SProxy :: SProxy "ace"

containerComponent
  :: forall unusedQuery unusedInput unusedOutput anyMonad
   . MonadAff anyMonad
  => H.Component HH.HTML unusedQuery unusedInput unusedOutput anyMonad
containerComponent = Hooks.component \rec _ -> Hooks.do
  msg /\ msgIdx <- Hooks.useState ""
  Hooks.pure $
    HH.div_
      [ HH.h1_
          [ HH.text "ace editor" ]
      , HH.div_
          [ HH.p_
              [ HH.button
                  [ HE.onClick \_ -> Just do
                      void $ Hooks.query rec.slotToken _ace unit $ H.tell (ChangeText "")
                  ]
                  [ HH.text "Clear" ]
              ]
          ]
      , HH.div_
          [ HH.slot _ace unit aceComponent unit \(TextChanged t) -> Just do
              Hooks.put msgIdx t
          ]
      , HH.p_
          [ HH.text ("Current text: " <> msg) ]
      ]

data ParentAction
  = ClearText
  | HandleAceUpdate AceOutput

data AceQuery a = ChangeText String a

data AceOutput = TextChanged String

aceElemLabel :: H.RefLabel
aceElemLabel = H.RefLabel "ace"

aceComponent
  :: forall unusedInput anyMonad
   . MonadAff anyMonad
  => H.Component HH.HTML AceQuery unusedInput AceOutput anyMonad
aceComponent = Hooks.component \rec _ -> Hooks.do
  state /\ stateIdx <- Hooks.useState (Nothing :: Maybe Editor)
  Hooks.useLifecycleEffect do
    Hooks.getHTMLElementRef aceElemLabel >>= traverse_ \element -> do
      editor <- liftEffect $ Ace.editNode element Ace.ace
      session <- liftEffect $ Editor.getSession editor
      Hooks.put stateIdx $ Just editor
      void $ Hooks.subscribe $ ES.effectEventSource \emitter -> do
        Session.onChange session \_ -> ES.emit emitter do
          Hooks.get stateIdx >>= traverse_ \editor' -> do
            text <- liftEffect (Editor.getValue editor')
            Hooks.raise rec.outputToken $ TextChanged text
        pure mempty
    pure $ Just do
      Hooks.put stateIdx Nothing

  Hooks.useQuery rec.queryToken case _ of
    ChangeText text next -> do
      maybeEditor <- Hooks.get stateIdx
      case maybeEditor of
        Nothing -> pure unit
        Just editor -> do
          current <- liftEffect $ Editor.getValue editor
          when (text /= current) do
            void $ H.liftEffect $ Editor.setValue text Nothing editor
      Hooks.raise rec.outputToken $ TextChanged text
      pure (Just next)

  Hooks.pure $
    HH.div [ HP.ref aceElemLabel ] []
