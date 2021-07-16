module RoutingHashLog.MyRouting where

import Prelude
import Data.Foldable (oneOf)
import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)
import Effect (Effect)
import Effect.Class.Console (log)
import Routing.Hash (matches)
import Routing.Match (Match, int, lit, str)

type PostId
  = Int

data MyRoute
  = PostIndex
  | Post PostId
  | PostEdit PostId
  | PostBrowse Int String

derive instance genericMyRoute :: Generic MyRoute _

instance showMyRoute :: Show MyRoute where
  show = genericShow

myRoute :: Match MyRoute
myRoute =
  lit "posts"
    *> oneOf
        [ PostEdit <$> int <* lit "edit"
        , Post <$> int
        , PostBrowse <$> (lit "browse" *> int) <*> str
        , pure PostIndex -- Unmatched goes to index too
        ]

logRoute :: Effect (Effect Unit)
logRoute =
  matches myRoute \oldRoute newRoute ->
    log $ show oldRoute <> " -> " <> show newRoute
