module RoutingHashReactHooks.Main where

import Prelude

import Data.Array as Array
import Data.Foldable as Foldable
import Data.Maybe (Maybe(..))
import Data.String as String
import Effect (Effect)
import Effect.Exception as Exception
import React.Basic (JSX)
import React.Basic as R
import React.Basic.DOM as R
import React.Basic.Hooks (Component, (/\))
import React.Basic.Hooks as React
import Routing.Hash as Hash
import Routing.Match (Match)
import Routing.Match as Match
import Web.HTML as HTML
import Web.HTML.HTMLDocument as HTMLDocument
import Web.HTML.HTMLElement as HTMLElement
import Web.HTML.Location as Location
import Web.HTML.Window as Window

main :: Effect Unit
main = do
  maybeBody <- HTMLDocument.body =<< Window.document =<< HTML.window
  case maybeBody of
    Nothing -> Exception.throw "Could not find body."
    Just body -> do
      app <- mkApp
      R.render (app unit) (HTMLElement.toElement body)

mkApp :: Component Unit
mkApp = do
  postIndex <- mkPostIndex
  post <- mkPost
  postEdit <- mkPostEdit
  React.component "App" \_ -> React.do
    route /\ setRoute <- React.useState' (Just Home)
    React.useEffectOnce do
      Hash.matches appRoute \_ newRoute -> setRoute newRoute
    React.useEffectOnce do
      -- A bit of a hack: this is setting the hash on initial page load, so that
      -- it defaults to the `Home` route (by default there is no hash, so no
      -- routes match and we'd show "Not found" on first render)
      location <- Window.location =<< HTML.window
      hash <- Location.hash location
      if String.null hash then Location.setHash "/" location else mempty
      pure mempty
    pure do
      R.fragment
        [ R.header_ [ headerNav ]
        , case route of
            Just Home -> R.h1_ [ R.text "Home" ]
            Just PostIndex -> postIndex unit
            Just (Post postId) -> post postId
            Just (PostEdit postId) -> postEdit postId
            Nothing -> R.h1_ [ R.text "Not found" ]
        ]

headerNav :: JSX
headerNav =
  R.nav_
    [ R.a
        { href: "#/posts"
        , children: [ R.text "Posts" ]
        }
    , R.text " | "
    , R.a
        { href: "#/"
        , children: [ R.text "Home" ]
        }
    ]

mkPostIndex :: Component Unit
mkPostIndex =
  React.component "PostIndex" \_ ->
    pure (R.ul_ postLinks)
  where
  postLinks =
    Array.range 1 10
      <#> \n ->
        R.li_
          [ R.a
              { href: "#/posts/" <> show n
              , children:
                  [ R.text ("Post " <> show n) ]
              }
          ]

mkPost :: Component Int
mkPost =
  React.component "Post" \n ->
    pure do
      R.fragment
        [ R.h1_ [ R.text ("Post " <> show n) ]
        , R.p_
            [ R.a
                { href: "#/posts/" <> show n <> "/edit"
                , children: [ R.text "Click here" ]
                }
            , R.text " to edit this post"
            ]
        ]

mkPostEdit :: Component Int
mkPostEdit =
  React.component "PostEdit" \n ->
    pure (R.h1_ [ R.text ("Edit post " <> show n) ])

data AppRoute
  = PostIndex
  | Post Int
  | PostEdit Int
  | Home

appRoute :: Match (Maybe AppRoute)
appRoute =
  Foldable.oneOf
    [ Just <$> postRoute
    , Just <$> (Match.root *> pure Home <* Match.end)
    , pure Nothing
    ]
  where
  postRoute =
    Match.root *> Match.lit "posts"
      *> Foldable.oneOf
        [ PostEdit <$> Match.int <* Match.lit "edit"
        , Post <$> Match.int
        , pure PostIndex
        ]
      <* Match.end
