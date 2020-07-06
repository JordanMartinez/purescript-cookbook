module RoutingPushHalogenClassic.MyRouting where

import Prelude
import Data.Foldable (oneOf)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Routing.Match (Match, int, lit, param, root, str)

type PostId
  = Int

data MyRoute
  = PostIndex
  | Post PostId
  | PostEdit PostId
  | PostBrowse Int String
  | ParamsAB String String

derive instance genericMyRoute :: Generic MyRoute _

instance showMyRoute :: Show MyRoute where
  show = genericShow

myRoute :: Match MyRoute
myRoute =
  root *> lit "posts"
    *> oneOf
        [ PostEdit <$> int <* lit "edit"
        , Post <$> int
        , PostBrowse <$> (lit "browse" *> int) <*> str
        , ParamsAB <$> (param "a") <*> (param "b")
        , pure PostIndex -- Unmatched goes to index too
        ]
