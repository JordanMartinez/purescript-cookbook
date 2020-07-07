module AddRemoveEventListenerJs.Main where

import Prelude

import Data.Interpolate (i)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Console (log)
import Effect.Ref as Ref
import Unsafe.Coerce (unsafeCoerce)
import Web.DOM.Element as Element
import Web.DOM.ParentNode (QuerySelector(..), querySelector)
import Web.Event.Event (EventType, Event)
import Web.Event.EventTarget (EventTarget, addEventListener, eventListener, removeEventListener)
import Web.HTML (window)
import Web.HTML.HTMLDocument as Document
import Web.HTML.Window (document)
import Web.UIEvent.MouseEvent (MouseEvent, screenX, screenY)
import Web.UIEvent.MouseEvent.EventTypes as METypes

main :: Effect Unit
main = do
  -- get the document
  win <- window
  doc <- document win

  -- get the buttons
  let docAsParent = Document.toParentNode doc
  mbButtonAddEL <- querySelector (QuerySelector "#addListenerButton") docAsParent
  mbButtonRemoveEL <- querySelector (QuerySelector "#removeListenerButton") docAsParent
  mbButtonMain <- querySelector (QuerySelector "#mainButton") docAsParent
  mbButtonRemove2nd <- querySelector (QuerySelector "#removeSecondApproach") docAsParent

  case mbButtonAddEL, mbButtonRemoveEL, mbButtonMain, mbButtonRemove2nd of
    Just bAddEL, Just bRemoveEL, Just bMain, Just bRemove2nd -> do
      let
      -- make it possible to add event listeners to these elements
      -- by changing their types from `Element` to `EventTarget`
        buttonAddEL     = Element.toEventTarget bAddEL
        buttonRemoveEL  = Element.toEventTarget bRemoveEL
        buttonMain      = Element.toEventTarget bMain
        buttonRemove2nd = Element.toEventTarget bRemove2nd

      -- In this first approach, we will add an event listener,
      -- and store a reference to that listener, so that we can
      -- remove it at a later time.
      -- We will only add/remove a single listener in this approach.
      ref <- Ref.new Nothing
      addMainListener <- eventListener \_ -> do
        mbListener <- Ref.read ref
        case mbListener of
          Nothing -> do
            log "Adding new listener."
            printMessageListener <- eventListener printMessage
            addEventListener
              METypes.click
              printMessageListener
              false -- use bubble phase, not capture phase
              buttonMain

            -- now store the listener inside the ref
            Ref.write (Just printMessageListener) ref
          Just _ -> do
            log "Listener already added. Not reinstalling listener."

      addEventListener METypes.click addMainListener false buttonAddEL

      removeMainListener <- eventListener \_ -> do
        mbListener <- Ref.read ref
        case mbListener of
          Just listener -> do
            log "Removing listener from main button."
            removeEventListener
              METypes.click
              listener
              false -- use bubble phase, not capture phase
              buttonMain

            Ref.write Nothing ref
          Nothing -> do
            log "No listener installed. Click 'Add Listener' button to add it."

      addEventListener METypes.click removeMainListener false buttonRemoveEL

      -- In this approach, we use a better approach to add an event listener
      -- where we don't need to store a reference to the listener since
      -- it is still in scope.
      removeListener <- addBetterListener METypes.click false buttonMain \e -> do
        log $ "Better listener: this is a better way to add/remove \
              \an event listener."

      remove2ndApproachListener <- eventListener \_ -> do
        log "Now removing event listener using better approach"
        removeListener
      addEventListener METypes.click remove2ndApproachListener false buttonRemove2nd

    _, _, _, _ -> do
      log $ "Could not get all three buttons. Please open an issue for this \
            \recipe on the PureScript cookbook."

printMessage :: Event -> Effect Unit
printMessage e = do
  let
    mouseEvent :: MouseEvent
    mouseEvent = unsafeCoerce e
  log "Triggered a mouse click event handler."
  log $ i "Screen X: "(show (screenX mouseEvent))"\n\
          \Screen Y: "(show (screenY mouseEvent))

-- | Intended usage:
-- | ```
-- | foo = do
-- |   removeEventListener <- addBetterListener click false button \e -> do
-- |      log "Run code when button is clicked..."
-- |   -- when you don't need it anymore, just run the Effect
-- |   removeEventListener -- much simpler
-- | ```
addBetterListener
  :: forall a
   . EventType -> Boolean -> EventTarget -> (Event -> Effect a) -> Effect (Effect Unit)
addBetterListener type_ useCaptureRatherThanBubble target listener = do
  evListener <- eventListener listener
  addEventListener type_ evListener useCaptureRatherThanBubble target
  pure $
    removeEventListener type_ evListener useCaptureRatherThanBubble target
