module DiceLog.Main where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Effect.Random (randomInt)
import Node.ReadLine (prompt, close, setLineHandler, setPrompt, noCompletion, createConsoleInterface)

main :: Effect Unit
main = do
  interface <- createConsoleInterface noCompletion
  setPrompt "Press <ENTER> to roll the die, or type \"q\" + <ENTER> to quit \n> " 2 interface
  prompt interface
  setLineHandler interface \s ->
    if s == "q" then
      close interface
    else do
      n <- randomInt 1 6
      log ("You rolled: " <> show n <> "\n")
      setPrompt "Press <ENTER> to roll again, or type \"q\" + <ENTER> to quit \n> " 2 interface
      prompt interface
