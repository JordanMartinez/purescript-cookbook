module AffjaxPostNode.Main where

import Data.Argonaut

import Affjax as AX
import Affjax.RequestBody (json)
import Affjax.ResponseFormat as ResponseFormat
import Data.Argonaut as J
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class.Console (log)
import Prelude (Unit, discard, class Show, bind, pure, show, ($), (<>))

-- Two versions are shown here, both produce the same output:
-- expected response: (at least if `http://jsonplaceholder.typicode.com/posts` is available to you)
-- POST http://jsonplaceholder.typicode.com/posts response: (Right { body: "body", id: (Just 101), title: "title", userId: 22 })

main :: Effect Unit
main = do
  version1
  version2

-- Version 1 - less boilerplate but be careful with versioning

type Post = { id     :: Maybe Int
            , title  :: String
            , body   :: String
            , userId :: Int
            }

postToJson :: Post -> Json
postToJson = encodeJson

jsonToPost :: Json -> Either JsonDecodeError Post
jsonToPost = decodeJson

version1 :: Effect Unit
version1 = launchAff_ $ do
  let 
    postdata :: Post
    postdata =  { id    : Nothing -- note how this returns filled-in if service works
                , title : "title"
                , body  : "body"
                , userId: 22 }

    endpoint :: String
    endpoint = "http://jsonplaceholder.typicode.com/posts"
    
  result <- AX.post ResponseFormat.json endpoint (Just $ json $ postToJson postdata)
  case result of

    Left err -> log $ "POST " <> endpoint <> " response failed to decode: " <> AX.printError err

    -- Right response -> do
    --     <> "POST " <> endpoint <> " response: " <> show (jsonToPost response.body)

    Right response -> do
      log $ "First version, Argonaut derivation of codecs "
        <> "POST " <> endpoint <> " response: " <> J.stringify response.body
        <> " >>> " <> show (jsonToPost response.body)



-- Version 2 - alternative implementation with explicit encodeJson and decodeJson follows
-- this approach tends to protect against ugly versioning problems
-- see https://code.slipthrough.net/2018/03/13/thoughts-on-typeclass-codecs/

data Post2 = Post2 Post
instance showPost2 :: Show Post2 where
  show (Post2 post) = show post

instance encodeJsonPost :: EncodeJson Post2 where
  encodeJson (Post2 post)
    = "id"      := post.id
    ~> "title"  := post.title
    ~> "body"   := post.body
    ~> "userId" := post.userId
    ~> jsonEmptyObject


instance decodeJsonPost :: DecodeJson Post2 where
  decodeJson json = do
    obj    <- decodeJson json
    id     <- obj .:? "id"
    title  <- obj .: "title"
    body   <- obj .: "body"
    userId <- obj .: "userId"
    pure $ Post2 { id, title, body, userId }


version2 :: Effect Unit
version2 = launchAff_ $ do
  let 
    postdata :: Post
    postdata =  { id    : Nothing -- note how this returns filled-in if service works
                , title : "title"
                , body  : "body"
                , userId: 22 }

    endpoint :: String
    endpoint = "http://jsonplaceholder.typicode.com/posts"
    
  result <- AX.post ResponseFormat.json endpoint (Just $ json $ encodeJson $ Post2 postdata)
  case result of

    Left err -> log $ "POST " <> endpoint <> " response failed to decode: " <> AX.printError err

    Right response ->
      log $ "Second version, explicit instances of codecs "
        <> "POST " <> endpoint <> " response: " <> J.stringify response.body
        <> " >>> " <> show ((decodeJson response.body) :: Either JsonDecodeError Post2)
