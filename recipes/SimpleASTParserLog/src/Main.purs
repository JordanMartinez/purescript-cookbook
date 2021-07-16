module SimpleASTParserLog.Main where

import Prelude hiding (between)

import Control.Alt ((<|>))
import Control.Lazy (defer, fix)
import Data.Either (Either(..))
import Data.Foldable (foldMap, for_, oneOf)
import Data.Function (on)
import Data.Int as Int
import Data.Maybe (Maybe(..))
import Data.Number as Number
import Data.String.CodeUnits (drop, take)
import Data.String.CodeUnits as SCU
import Effect (Effect)
import Effect.Console (log)
import Text.Parsing.StringParser (Parser, fail, try, unParser)
import Text.Parsing.StringParser.CodeUnits (anyDigit, char, skipSpaces, string)
import Text.Parsing.StringParser.Combinators (between, many1, (<?>))

-- | Language only supports the following:
-- | - basic binary operations (e.g. +, -, /, *)
-- | - literal integers or numbers (e.g. 4, 4.0), which cannot use a thousandth
-- |     separator (e.g. `10000` not `10,000`)
-- | - parenthesis
mathProblems :: Array String
mathProblems =
  [ "1 + 2 * 3 - 4 / 5"
  , "(-1) + 2 - ((3 + 4) - 5) * (-(6 + 7 * (8 + 9))) / -10"
  , "-1 + -2 - -3 - -4 * 4 * 5 * -6"
  ]

-- | Set this to `true` if you want to see the structure printed to the console
-- | as well.
showStructure :: Boolean
showStructure = true

main :: Effect Unit
main = do
  for_ mathProblems \prob -> do
    log "" -- add a blank line as separator
    log $ "Problem is: " <> prob
    case unParser parseExpr {str:prob, pos: 0} of
      Left e -> do
        log $ show e.error <>
          "\nleft side: `"  <> take e.pos prob <>
          "\nright side: `" <> drop e.pos prob <> "`"
      Right r -> do
        log $ (show $ evalExpr r.result) <> " = " <> printExpr r.result
        when showStructure do
          log $ "Structure is: " <> show r.result

-- The Parser below uses a "precedence climbing" approach

data Expr
  = BinaryOp Expr BinaryOperator Expr
  | UnaryOp UnaryExpr

data BinaryOperator = Plus | Minus | Multiply | Divide
data Sign = Negative | Positive

data UnaryExpr
  = Unary Sign Atom

data Atom
  = LitInt Int
  | LitNum Number
  | Parenthesis Expr

-- Parsers

parseExpr :: Parser Expr
parseExpr = fix \parseInfix -> do
  left <- UnaryOp <$> lazyParseUnaryExpr
  try (parseRightHandSide left parseInfix) <|> pure left
  where
    lazyParseUnaryExpr :: Parser UnaryExpr
    lazyParseUnaryExpr = defer \_ -> parseUnaryExpr

    operatorPrecedence :: BinaryOperator -> Int
    operatorPrecedence = case _ of
      Plus -> 1
      Minus -> 1
      Multiply -> 2
      Divide -> 2

    parseRightHandSide :: Expr -> Parser Expr -> Parser Expr
    parseRightHandSide left parseInfix = do
      leftOp <- try $ between skipSpaces skipSpaces parseBinaryOperator
      nextPart <- parseInfix
      pure case nextPart of
        UnaryOp right -> do
          -- no need to handle operator precedence on a UnaryExpr
          BinaryOp left leftOp nextPart

        BinaryOp middle rightOp right ->
          -- Evaluation runs from left to right. Ensure we have fully evaluated
          -- the left part before we evaluate the right part by reassociating
          -- terms with the correct operations.
          case (compare `on` operatorPrecedence) leftOp rightOp of
            LT -> do
              -- No term reassociation here because leftOp < rightOp
              -- For example
              --   `1 + 2 * 4` becomes `(1 + (2 * 4))`
              BinaryOp left leftOp nextPart

            _ {- GT or EQ -} -> do
              -- Always reassociate terms here
              -- For example:
              --  `1 * 2 + 4` becomes `((1 * 2) + 4)`
              BinaryOp (BinaryOp left leftOp middle) rightOp right

    parseBinaryOperator :: Parser BinaryOperator
    parseBinaryOperator = do
      oneOf [ Multiply <$ string "*"
            , Divide <$ string "/"
            , Plus <$ string "+"
            , Minus <$ string "-"
            , fail "Could not parse a binary operator"
            ]

parseUnaryExpr :: Parser UnaryExpr
parseUnaryExpr = do
  sign <- (Negative <$ char '-') <|> pure Positive
  atom <- lazyParseAtom
  pure $ Unary sign atom
  where
    lazyParseAtom :: Parser Atom
    lazyParseAtom = defer \_ -> parseAtom

parseAtom :: Parser Atom
parseAtom = do
  parseLiteral <|> parseParenthesis
  where
    parseNumber :: String -> Parser Atom
    parseNumber digitsAsString = do
      void $ string "." -- decimal point
      decimalsAsString <- parseNumSequence
      let fullString = digitsAsString <> "." <> decimalsAsString
      case Number.fromString fullString of
        Just x | Number.isFinite x -> pure $ LitNum x
        _ -> fail $ "Not a valid decimal: " <> fullString

    parseInt :: String -> Parser Atom
    parseInt digitsAsString = case Int.fromString digitsAsString of
      Just i ->  pure $ LitInt i
      Nothing -> fail $
        "String of digit characters `" <> digitsAsString <>
        "` is outside the bounds of `Int`"

    parseLiteral :: Parser Atom
    parseLiteral = do
      digitsAsString <- parseNumSequence
      try (parseNumber digitsAsString) <|> (parseInt digitsAsString)

    lazyParseExpr :: Parser Expr
    lazyParseExpr = defer \_ -> parseExpr

    parseParenthesis :: Parser Atom
    parseParenthesis = do
      between (char '(') (char ')') do
        between skipSpaces skipSpaces do
          Parenthesis <$> lazyParseExpr

parseNumSequence :: Parser String
parseNumSequence = do
  digitCharList <- (many1 anyDigit) <?> "Did not find 1 or more digit characters"
  pure $ foldMap SCU.singleton digitCharList

-- Evaluators

evalExpr :: Expr -> Number
evalExpr = case _ of
  BinaryOp l op r -> (evalOp op) (evalExpr l) (evalExpr r)
  UnaryOp unaryExpr -> evalUnaryExpr unaryExpr
  where
    evalOp :: forall a. EuclideanRing a => BinaryOperator -> (a -> a -> a)
    evalOp = case _ of
      Plus -> (+)
      Minus -> (-)
      Multiply -> (*)
      Divide -> (/)

evalUnaryExpr :: UnaryExpr -> Number
evalUnaryExpr = case _ of
  Unary sign atom -> case sign of
    Positive -> evalAtom atom
    Negative -> negate (evalAtom atom)

evalAtom :: Atom -> Number
evalAtom = case _ of
  LitInt i -> Int.toNumber i
  LitNum n -> n
  Parenthesis expr -> evalExpr expr

-- Printers

printExpr :: Expr -> String
printExpr = case _ of
  BinaryOp l op r -> (printExpr l) <> " " <> (printOp op) <> " " <> (printExpr r)
  UnaryOp unaryExpr -> printUnaryExpr unaryExpr
  where
    printOp :: BinaryOperator -> String
    printOp = case _ of
      Plus -> "+"
      Minus -> "-"
      Multiply -> "*"
      Divide -> "/"

printUnaryExpr :: UnaryExpr -> String
printUnaryExpr = case _ of
  Unary sign atom -> case sign of
    Positive -> printAtom atom
    Negative -> "-" <> (printAtom atom)

printAtom :: Atom -> String
printAtom = case _ of
  LitInt i -> show i
  LitNum n -> show n
  Parenthesis expr -> "(" <> printExpr expr <> ")"

-- type class instances

derive instance eqUnaryExpr :: Eq UnaryExpr
derive instance ordUnaryExpr :: Ord UnaryExpr
instance showUnaryExpr :: Show UnaryExpr where
  show (Unary sign atom) = "Unary(" <> show sign <> " " <> show atom <> ")"

derive instance eqAtom :: Eq Atom
derive instance ordAtom :: Ord Atom
instance showAtom :: Show Atom where
  show = case _ of
    LitInt i -> "LitInt " <> show i
    LitNum n -> "LitNum " <> show n
    Parenthesis content -> "Parenthesis(" <> show content <> ")"

derive instance eqExpr :: Eq Expr
derive instance ordExpr :: Ord Expr
instance showExpr :: Show Expr where
  show = case _ of
    BinaryOp l op r ->
      "BinaryOp(" <> show l <> " " <> show op <> " " <> show r <> ")"
    UnaryOp unary -> "UnaryOp(" <> show unary <> ")"

derive instance eqBinaryOperator :: Eq BinaryOperator
derive instance ordBinaryOperator :: Ord BinaryOperator
instance showBinaryOperator :: Show BinaryOperator where
  show = case _ of
    Plus -> "+"
    Minus -> "-"
    Multiply -> "*"
    Divide -> "/"

derive instance eqSign :: Eq Sign
derive instance ordSign :: Ord Sign
instance showSign :: Show Sign where
  show = case _ of
    Positive -> "Positive"
    Negative -> "Negative"
