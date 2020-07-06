module WindowPropertiesJs.Main where

import Prelude

import Data.Interpolate (i)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Console (log)
import Web.HTML (Window, window)
import Web.HTML.HTMLDocument (body, title)
import Web.HTML.Window (alert, confirm, document, innerHeight, innerWidth, open, outerHeight, outerWidth, scrollX, scrollY)

main :: Effect Unit
main = do
  win <- window
  alert "We will now print your window's width and height to the console." win
  printWindowValues win

  alert "We will now print things related to the window's `document`." win
  doc <- document win
  t <- title doc
  log $ "Title: " <> t

  mbBody <- body doc
  case mbBody of
    Nothing -> do
      log "No body element found"
    Just _ -> do
      log "Body element found"

  let url = "https://github.com"
  openUrl <- confirm ("Should we open a new modal window to " <> url) win
  if openUrl then do
    mbWin2 <- open url "_blank" "top=20 left=20 height=400 width=400" win
    case mbWin2 of
      Nothing -> do
        log "Could not open a modal window."
      Just win2 -> do
        log "Now printing values of the modal window"
        printWindowValues win2
  else do
    log "User decided not to open a modal window."

printWindowValues :: Window -> Effect Unit
printWindowValues win = do
  currentInnerWidth <- innerWidth win
  currentInnerHeight <- innerHeight win
  currentOuterWidth <- outerWidth win
  currentOuterHeight <- outerHeight win
  currentScrollX <- scrollX win
  currentScrollY <- scrollY win
  log $ i
    "inner width: "(show currentInnerWidth)"\n\
    \inner height: "(show currentInnerHeight)"\n\
    \outer width: "(show currentOuterWidth)"\n\
    \outer height: "(show currentOuterHeight)"\n\
    \scroll x: "(show currentScrollX)"\n\
    \scroll y: "(show currentScrollY)
