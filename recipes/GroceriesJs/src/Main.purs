module GroceriesJs.Main where

import Prelude

import Data.Foldable (traverse_)
import Data.Maybe (maybe)
import Effect (Effect)
import Effect.Exception (throw)
import Web.DOM (Document, Node)
import Web.DOM.Document (createElement)
import Web.DOM.Element as Element
import Web.DOM.Node (appendChild, setTextContent)
import Web.HTML (window)
import Web.HTML.HTMLDocument as HTMLDocument
import Web.HTML.HTMLElement as HTMLElement
import Web.HTML.Window (document)

main :: Effect Unit
main = do
  htmlDoc <- document =<< window
  body <- maybe (throw "Could not find body element") pure =<< HTMLDocument.body htmlDoc
  let
    doc = HTMLDocument.toDocument htmlDoc

  -- Create DOM elements
  divElem <- createElement "div" doc
  h1Elem <- createElement "h1" doc
  ulElem <- createElement "ul" doc

  -- Convert DOM (or HTML) elements to DOM nodes
  let
    bodyNode = HTMLElement.toNode body
    divNode = Element.toNode divElem
    h1Node = Element.toNode h1Elem
    ulNode = Element.toNode ulElem

  -- Fill in some contents
  setTextContent "My Grocery List" h1Node

  -- Define structure in DOM
  void $ appendChild divNode bodyNode
  void $ appendChild h1Node divNode
  void $ appendChild ulNode divNode
  traverse_ (makeAndAppendLiNode doc ulNode) groceryList

makeAndAppendLiNode :: Document -> Node -> String -> Effect Unit
makeAndAppendLiNode doc parentNode text = do
  liElem <- createElement "li" doc
  let
    liNode = Element.toNode liElem
  setTextContent text liNode
  appendChild liNode parentNode

groceryList :: Array String
groceryList =
  [ "Black Beans"
  , "Limes"
  , "Greek Yogurt"
  , "Cilantro"
  , "Honey"
  , "Sweet Potatoes"
  , "Cumin"
  , "Chili Powder"
  , "Quinoa"
  ]
