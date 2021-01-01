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
import Prelude (Unit, bind, show, ($), (<>))

-- expected response: (at least if `http://jsonplaceholder.typicode.com/posts` is available to you)
-- POST http://jsonplaceholder.typicode.com/posts response: (Right { body: "body", id: (Just 101), title: "title", userId: 22 })

type Post = { id     :: Maybe Int
            , title  :: String
            , body   :: String
            , userId :: Int
            }

postToJson :: Post -> Json
postToJson = encodeJson

jsonToPost :: Json -> Either JsonDecodeError Post
jsonToPost = decodeJson

main :: Effect Unit
main = launchAff_ $ do
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

    Left err -> 
      log $ "POST " <> endpoint <> " response failed to decode: " <> AX.printError err

    Right response -> do
      log $ "POST " <> endpoint <> " response: " <> J.stringify response.body
         <> "\n>>> " <> show (jsonToPost response.body)
