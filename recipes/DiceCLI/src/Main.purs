module DiceCLI.Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import Effect.Random (randomInt)
import Node.ReadLine (close, createConsoleInterface, noCompletion, prompt, setLineHandler, setPrompt)

main :: Effect Unit
main = do
  interface <- createConsoleInterface noCompletion
  setPrompt "Press <ENTER> to roll the die, or type \"q\" + <ENTER> to quit \n> " interface
  prompt interface
  interface # setLineHandler \s ->
    if s == "q" then
      close interface
    else do
      n <- randomInt 1 6
      log ("You rolled: " <> show n <> "\n")
      setPrompt "Press <ENTER> to roll again, or type \"q\" + <ENTER> to quit \n> " interface
      prompt interface
