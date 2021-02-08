module RoutingPushReactHooks.Main where

import Prelude
import Control.Monad.Reader (ReaderT(..))
import Control.Monad.Reader as Reader
import Data.Array as Array
import Data.Foldable as Foldable
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Class as Effect.Class
import Effect.Exception as Exception
import Foreign as Foreign
import Partial.Unsafe as Partial.Unsafe
import React.Basic (JSX, ReactContext)
import React.Basic as React.Basic
import React.Basic.DOM as R
import React.Basic.DOM.Events as DOM.Events
import React.Basic.Events as Events
import React.Basic.Hooks (Hook, UseContext, (/\), Render)
import React.Basic.Hooks as React
import Routing.Match (Match)
import Routing.Match as Match
import Routing.PushState (PushStateInterface)
import Routing.PushState as PushState
import Web.HTML as HTML
import Web.HTML.HTMLDocument as HTMLDocument
import Web.HTML.HTMLElement as HTMLElement
import Web.HTML.Window as Window

main :: Effect Unit
main = do
  maybeBody <- HTMLDocument.body =<< Window.document =<< HTML.window
  case maybeBody of
    Nothing -> Exception.throw "Could not find body."
    Just body -> do
      routerContext <- mkRouterContext
      routerProvider <- Reader.runReaderT mkRouterProvider routerContext
      app <- Reader.runReaderT mkApp routerContext
      R.render
        (routerProvider [ app unit ])
        (HTMLElement.toElement body)

-- | Note that we are not using `React.Basic.Hooks.Component` here, replacing it
-- | instead with a very similar type, that has some extra "environment"
-- | provided by `ReaderT` (namely the `RouterContext` that we need to pass to
-- | `useRouterContext`). By using `ReaderT` we can avoid explicitly threading
-- | the context through to all the components that use it, instead we can just
-- | use `ask` to access it as needed.
type Component props
  = ReaderT RouterContext Effect (props -> JSX)

component ::
  forall props hooks.
  String -> (props -> Render Unit hooks JSX) -> Component props
component name render = ReaderT \_ -> React.component name render

mkApp :: Component Unit
mkApp = do
  routerContext <- Reader.ask
  postIndex <- mkPostIndex
  post <- mkPost
  postEdit <- mkPostEdit
  headerNav <- mkHeaderNav
  component "App" \_ -> React.do
    { route } <- useRouterContext routerContext
    pure do
      React.Basic.fragment
        [ R.header_ [ headerNav unit ]
        , case route of
            Just Home -> R.h1_ [ R.text "Home" ]
            Just PostIndex -> postIndex unit
            Just (Post postId) -> post postId
            Just (PostEdit postId) -> postEdit postId
            Nothing -> R.h1_ [ R.text "Not found" ]
        ]

mkHeaderNav :: Component Unit
mkHeaderNav = do
  link <- mkLink
  component "Link" \_ ->
    pure do
      R.nav_
        [ link
            { to: "/posts"
            , children: [ R.text "Posts" ]
            }
        , R.text " | "
        , link
            { to: "/"
            , children: [ R.text "Home" ]
            }
        ]

mkPostIndex :: Component Unit
mkPostIndex = do
  link <- mkLink
  component "PostIndex" \_ ->
    pure do
      R.ul_
        ( Array.range 1 10
            <#> \n ->
                R.li_
                  [ link
                      { to: "/posts/" <> show n
                      , children:
                          [ R.text ("Post " <> show n) ]
                      }
                  ]
        )

mkPost :: Component Int
mkPost = do
  link <- mkLink
  component "Post" \n ->
    pure do
      React.Basic.fragment
        [ R.h1_ [ R.text ("Post " <> show n) ]
        , R.p_
            [ link
                { to: "/posts/" <> show n <> "/edit"
                , children: [ R.text "Click here" ]
                }
            , R.text " to edit this post"
            ]
        ]

mkPostEdit :: Component Int
mkPostEdit =
  component "PostEdit" \n ->
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

type RouterContextValue
  = { route :: Maybe AppRoute
    , nav :: PushStateInterface
    }

-- | Note that we actually want a `RouterContextValue` where the context is
-- | being consumed, not a `Maybe RouterContextValue`, but `createContext`
-- | requires an "initial" value to use as a fallback in the case that the
-- | context is used with no context provider. One solution would be to
-- | construct a "dummy" value of type `RouterContextValue` that could work as a
-- | sensible default. Another solution is to consider the use of the context
-- | where it's not provided as *unintended behavior*, as described in this
-- | article (in JS):
-- | https://kentcdodds.com/blog/how-to-use-react-context-effectively.
-- | *tl;dr* -- In JavaScript, the approach is to pass `undefined` or `null` as
-- | the initial value and then instead of consuming the context directly at the
-- | component level via `useContext`, to implement a custom hook that wraps
-- | `useContext` and throws an error if the context is used where it's not
-- | provided (signalling that this is not a use case we want to support). We've
-- | done similar, by wrapping our context value in `Maybe` and using `Nothing`
-- | as the case that we pattern-match on to trigger the error.
type RouterContext
  = ReactContext (Maybe RouterContextValue)

-- | An alternative would be to use `unsafePerformEffect` to have a "global"
-- | `RouterContext` (not wrapped in `Effect`) that could be used directly
-- | inside of `useRouterContext` instead of binding it in the top-level
-- | component "bootstrapping" phase (inside of `main :: Effect Unit`) and
-- | passing it down the component tree from there (as we're doing).
mkRouterContext :: Effect RouterContext
mkRouterContext = React.createContext Nothing

useRouterContext ::
  RouterContext ->
  Hook (UseContext (Maybe RouterContextValue)) RouterContextValue
useRouterContext routerContext = React.do
  maybeContextValue <- React.useContext routerContext
  pure case maybeContextValue of
    -- If we have no context value from a provider, we throw a fatal error
    Nothing ->
      Partial.Unsafe.unsafeCrashWith
        "useContext can only be used in a descendant of \
        \the corresponding context provider component"
    Just contextValue -> contextValue

mkRouterProvider :: Component (Array JSX)
mkRouterProvider = do
  routerContext <- Reader.ask
  nav <- Effect.Class.liftEffect PushState.makeInterface
  component "Router" \children -> React.do
    let
      routerProvider = React.Basic.provider routerContext
    route /\ setRoute <- React.useState' (Just Home)
    React.useEffectOnce do
      nav
        # PushState.matches appRoute \_ newRoute -> do
            setRoute newRoute
    pure (routerProvider (Just { nav, route }) children)

mkLink :: Component { to :: String, children :: Array JSX }
mkLink = do
  routerContext <- Reader.ask
  component "Link" \{ to, children } -> React.do
    { nav } <- useRouterContext routerContext
    pure do
      R.a
        { href: to
        , onClick:
            Events.handler
              DOM.Events.preventDefault \_ -> do
              nav.pushState (Foreign.unsafeToForeign unit) to
        , children
        }
