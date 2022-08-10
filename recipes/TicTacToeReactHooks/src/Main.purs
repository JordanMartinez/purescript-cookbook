module TicTacToeReactHooks.Main where

import Prelude

import Control.Alt ((<|>))
import Data.Array (concat, (:))
import Data.Array as Array
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmpty
import Data.Eq.Generic (genericEq)
import Data.Foldable (or)
import Data.Generic.Rep (class Generic)
import Data.Int (even)
import Data.Maybe (Maybe(..), fromMaybe, isJust)
import Data.Show.Generic (genericShow)
import Effect (Effect)
import Effect.Exception (throw)
import React.Basic.DOM (CSS, css, render)
import React.Basic.DOM as R
import React.Basic.Events (EventHandler, handler_)
import React.Basic.Hooks (Component, JSX, Reducer, component, keyed, mkReducer, useReducer, (/\))
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
      text = case props.value of
        Just player -> show player
        Nothing -> ""
    pure
      $ R.button
          { style: styles.square
          , onClick: props.onClick
          , children: [ R.text text ]
          }

type Square = Maybe Player

data Player
  = X
  | O

derive instance genericPlayer :: Generic Player _

instance showPlayer :: Show Player where
  show = genericShow

instance eqPlayer :: Eq Player where
  eq = genericEq

mkBoard
  :: Component
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
              { style: styles.boardRow
              , children: [ 0, 1, 2 ] <#> renderSquare 0
              }
          , R.div
              { style: styles.boardRow
              , children: [ 0, 1, 2 ] <#> renderSquare 1
              }
          , R.div
              { style: styles.boardRow
              , children: [ 0, 1, 2 ] <#> renderSquare 2
              }
          ]

data Action
  = JumpToStep Int
  | FillSquare Int Int

type BoardState = Int -> Int -> Square

type State =
  { history :: NonEmptyArray BoardState
  , stepNumber :: Int
  , xIsNext :: Boolean
  }

reducerFn :: Effect (Reducer State Action)
reducerFn =
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

initialState :: State
initialState =
  { history: NonEmpty.singleton (\_ _ -> Nothing)
  , stepNumber: 0
  , xIsNext: true
  }

mkGame :: Component Unit
mkGame = do
  board <- mkBoard
  reducer <- reducerFn
  component "Game" \_ -> React.do
    state /\ dispatch <- useReducer initialState reducer
    let
      current :: BoardState
      current =
        state.history `NonEmpty.index` state.stepNumber
          # fromMaybe (NonEmpty.head initialState.history)

      renderMove :: String -> Int -> JSX
      renderMove text n =
        keyed (show n)
          ( R.li_
              [ R.button
                  { onClick: handler_ (dispatch (JumpToStep n))
                  , children: [ R.text text ]
                  }
              ]
          )

      moves :: Array JSX
      moves =
        renderMove "Go to start" 0
          : Array.mapWithIndex (\i _ -> renderMove ("Go to move #" <> show (i + 1)) (i + 1)) (NonEmpty.tail state.history)

      status :: String
      status = case calculateWinner current of
        Just winner -> "Winner: " <> show winner
        Nothing -> "Next player: " <> if state.xIsNext then "X" else "O"
    pure
      $ R.div
          { style: styles.game
          , children:
              [ R.div
                  { children:
                      [ board
                          { onClick:
                              \i j -> handler_ (dispatch (FillSquare i j))
                          , squares: current
                          }
                      ]
                  }
              , R.div
                  { style: styles.gameInfo
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
        -- Check for a row full of player 'p'
        [ [ 0, 1, 2 ] <#> \i -> [ 0, 1, 2 ] <#> \j -> f i j
        -- Check for a full column
        , [ 0, 1, 2 ] <#> \j -> [ 0, 1, 2 ] <#> \i -> f i j
        -- Check diagonals
        , [ [ 0, 1, 2 ] <#> \k -> f k k ]
        , [ [ 0, 1, 2 ] <#> \k -> f k (2 - k) ]
        ]
          # concat
              >>> map (Array.all (_ == Just p))
              >>> or then
        Just p
      else
        Nothing
  in
    winByPlayer X <|> winByPlayer O

-- These styles could be provided by a proper stylesheet, we are only
-- defining them here for the sake of compatibility with TryPureScript
styles
  :: { list :: CSS
     , boardRow :: CSS
     , square :: CSS
     , game :: CSS
     , gameInfo :: CSS
     }
styles =
  { list:
      css
        { paddingLeft: "30px"
        }
  , boardRow:
      css
        { "&:after":
            { clear: "both"
            , content: "\"\""
            , display: "table"
            }
        }
  , square:
      css
        { background: "#fff"
        , border: "1px solid #999"
        , float: "left"
        , fontSize: "24px"
        , fontWeight: "bold"
        , lineHeight: "34px"
        , height: "34px"
        , marginRight: "-1px"
        , marginTop: "-1px"
        , padding: "0"
        , textAlign: "center"
        , width: "34px"
        , "&:focus":
            { outline: "none"
            , background: "#dd"
            }
        }
  , game:
      css
        { display: "flex"
        , flexDirection: "row"
        , font: "14px \"Century Gothic\", Futura, sans-serif"
        }
  , gameInfo:
      css
        { marginLeft: "20px"
        }
  }
