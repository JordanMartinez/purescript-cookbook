module TicTacToeReactHooks.Main where

import Prelude
import Control.Alt ((<|>))
import Data.Array ((:))
import Data.Array as Array
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmpty
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Eq (genericEq)
import Data.Generic.Rep.Show (genericShow)
import Data.Int (even)
import Data.Maybe (Maybe(..), fromMaybe, isJust)
import Effect (Effect)
import Effect.Exception (throw)
import React.Basic.DOM (render)
import React.Basic.DOM as R
import React.Basic.Events (EventHandler, handler_)
import React.Basic.Hooks (Component, component, keyed, mkReducer, useReducer, (/\))
import React.Basic.Hooks as React
import Web.HTML (window)
import Web.HTML.HTMLDocument (body)
import Web.HTML.HTMLElement (toElement)
import Web.HTML.Window (document)

main :: Effect Unit
main = do
  body <- body =<< document =<< window
  case body of
    Nothing -> throw "Could not find body."
    Just b -> do
      game <- mkGame
      render (game unit) (toElement b)
      mempty

mkSquare :: Component { onClick :: EventHandler, value :: Square }
mkSquare =
  component "Square" \props -> React.do
    let
      value' = case props.value of
        Just player -> show player
        Nothing -> ""
    pure
      $ R.button
          { className: "square"
          , onClick: props.onClick
          , children: [ R.text value' ]
          }

type Square
  = Maybe Player

data Player
  = X
  | O

derive instance genericPlayer :: Generic Player _

instance showPlayer :: Show Player where
  show = genericShow

instance eqPlayer :: Eq Player where
  eq = genericEq

mkBoard ::
  Component
    { onClick :: Int -> Int -> EventHandler
    , squares :: BoardState
    }
mkBoard = do
  square <- mkSquare
  component "Board" \props -> React.do
    let
      renderSquare i j = square { value: props.squares i j, onClick: props.onClick i j }
    pure
      $ R.div_
          [ R.div
              { className: "board-row"
              , children: [ 0, 1, 2 ] <#> renderSquare 0
              }
          , R.div
              { className: "board-row"
              , children: [ 0, 1, 2 ] <#> renderSquare 1
              }
          , R.div
              { className: "board-row"
              , children: [ 0, 1, 2 ] <#> renderSquare 2
              }
          ]

data Action
  = JumpToStep Int
  | FillSquare Int Int

type BoardState = Int -> Int -> Square

type State
  = { history :: NonEmptyArray BoardState
    , stepNumber :: Int
    , xIsNext :: Boolean
    }

mkGame :: Component Unit
mkGame = do
  board <- mkBoard
  reducer <-
    mkReducer \state -> case _ of
      JumpToStep n ->
        state
          { stepNumber = n
          , xIsNext = even n
          }
      FillSquare i j ->
        let
          history' :: NonEmptyArray BoardState
          history' =
            let
              { head, tail } = NonEmpty.uncons state.history
            in
              head `NonEmpty.cons'` Array.slice 0 state.stepNumber tail

          current :: BoardState
          current = NonEmpty.last history'

          next :: BoardState
          next i' j'
            | i' == i && j' == j = if state.xIsNext then Just X else Just O
            | otherwise = current i' j'
        in
          if isJust (calculateWinner current) || isJust (current i j) then
            state
          else
            state
              { history = history' `NonEmpty.snoc` next
              , stepNumber = NonEmpty.length history'
              , xIsNext = not state.xIsNext
              }
  component "Game" \_ -> React.do
    let
      initialState :: State
      initialState =
        { history: NonEmpty.singleton (\_ _ -> Nothing)
        , stepNumber: 0
        , xIsNext: true
        }
    state /\ dispatch <- useReducer initialState reducer
    let
      current =
        state.history `NonEmpty.index` state.stepNumber
          # fromMaybe (NonEmpty.head initialState.history)

      moves =
        let
          { head, tail } = NonEmpty.uncons state.history

          renderMove text n =
            keyed (show n)
              ( R.li_
                  [ R.button
                      { onClick:
                          handler_ do
                            dispatch (JumpToStep n)
                      , children: [ R.text text ]
                      }
                  ]
              )
        in
          renderMove "Go to start" 0
            : Array.mapWithIndex (\i _ -> renderMove ("Go to move # " <> show (i + 1)) (i + 1)) tail

      status = case calculateWinner current of
        Just winner -> "Winner: " <> show winner
        Nothing -> "Next player: " <> if state.xIsNext then "X" else "O"
    pure
      $ R.div
          { className: "game"
          , children:
              [ R.div
                  { className: "game-board"
                  , children:
                      [ board
                          { onClick:
                              \i j ->
                                handler_ do
                                  dispatch (FillSquare i j)
                          , squares: current
                          }
                      ]
                  }
              , R.div
                  { className: "game-info"
                  , children:
                      [ R.div_ [ R.text status ]
                      , R.ol_ moves
                      ]
                  }
              ]
          }

calculateWinner :: BoardState -> Maybe Player
calculateWinner f =
  let
    winByPlayer :: Player -> Maybe Player
    winByPlayer p =
      if 
        -- Check for a full row of player 'p'
        Array.any (\i -> Array.all (\j -> f i j == Just p) [ 0, 1, 2 ]) [ 0, 1, 2 ]
          -- Check for a full column
          || Array.any (\j -> Array.all (\i -> f i j == Just p) [ 0, 1, 2 ]) [ 0, 1, 2 ]
          -- Check diagonals
          || Array.all (\k -> f k k == Just p) [ 0, 1, 2 ]
          || Array.all (\k -> f k (2 - k) == Just p) [ 0, 1, 2 ]
        then Just p
        else Nothing
  in
    winByPlayer X <|> winByPlayer O
