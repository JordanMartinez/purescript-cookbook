module PayloadHttpApiNode.Main where

import Prelude

import Data.Either (Either(..))
import Data.Map (Map)
import Data.Map as Map
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.AVar (AVar)
import Effect.AVar as EffVar
import Effect.Aff (Aff)
import Effect.Aff.AVar as AffVar
import Payload.ResponseTypes (Failure(..))
import Payload.Server as Payload
import Payload.Spec (GET, Spec(Spec), POST)

-- | This is used as a return type for whenever we don't have something
-- | meaningful to return.
type StatusCodeResponse =
    { statusCode :: Int
    , statusMessage :: String
    }

-- | Our API is all about quotes, and this is how we represent a single quote.
type Quote =
    { text :: String
    , id :: Int
    }

-- | This fully describes our API as a big record under the 'Spec' constructor.
-- |
-- | Each label represents an endpoint in our quote API:
-- | 'quote' is a GET-by-id endpoint. We match the URL by the <id> parameter.
-- | 'addQUote' is a POST-to-insert a new quote. The body is just a string.
-- | 'getAll' is a GET everything in our quote 'database'.
-- |
-- | The response type is also encoded in each endpoint.
-- | Note that the implementation is trivial: this only represents type-level
-- | information used downstream.
spec
    :: Spec
        { quote :: GET "/quote/<id>"
            { params :: { id :: Int }
            , response :: String
            }
        , addQuote :: POST "/quote"
            { body :: String
            , response :: StatusCodeResponse
            }
        , getAll :: GET "/quote"
            { response :: Array Quote
            }
        }
spec = Spec

-- | This is where everything comes together: we create a record of HANDLERS
-- | for each of the routes we defined in 'spec'.
-- | The types must follow the definitions, so for example 'quote' must take
-- | a record containing "params :: { id :: Int }".
-- |
-- | Note that we are taking an 'AVar (Map Int String)'. We do this in order to
-- | keep state across calls.
-- |
-- | AVars are variables that you can read and update within an 'Aff' context.
-- | The 'AVar' created in 'main' is threaded through 'handlers' to each
-- | individual handler.
handlers :: _
handlers quotes =
    { quote: quote quotes
    , addQuote: addQuote quotes
    , getAll: getAll quotes
    }

-- | Main entry point: we just create a new 'AVar' (fake "database") and
-- | launch the payload server.
main :: Effect Unit
main = do
    quotes <- EffVar.new $ Map.singleton 1 "This is a quote"
    Payload.launch spec (handlers quotes)

-- | This represents our application's state. It's essentially our database
-- | (except it gets reset when application gets restarted).
type State = AVar (Map Int String)

-- | This is the handler for getting a quote by id.
-- | We start by reading the "database".
-- | If we can't find the requested 'id', then we just return an error.
-- | Otherwise, we return the requested quote.
quote :: State -> { params :: { id :: Int } } -> Aff (Either Failure String)
quote st { params : {id} } = do
    quotes <- AffVar.read st
    case Map.lookup id quotes of
        Nothing -> pure $ Left $ Forward ""
        Just v -> pure (pure v)

-- | Adding a quote requires us to 'block' reads/writes to our 'database', which
-- | is precisely what 'take' does.
-- | We then look for the highest id in the 'database' and increment it by one.
-- | We finish off by 'unblocking' and pushing our updated 'database'.
addQuote :: State -> { body :: String } -> Aff StatusCodeResponse
addQuote st { body } = do
    quotes <- AffVar.take st
    id <- case Map.findMax quotes of
        Nothing -> pure 1
        Just { key } -> pure (key + 1)
    AffVar.put (Map.insert id body quotes) st
    pure { statusCode: 200, statusMessage: body }

-- | We start by reading the current 'database'. Since we can't easily encode
-- | a Map structure directly, we transform it to an Array by calling
-- | 'toUnfoldable' (the map works over 'Aff').
-- | Our type now is 'Aff (Array (Tuple Int String))'. Unfortunately, 'Tuples'
-- | are also not trivial to encode, so we also need to 'map' over the
-- | Array and change all Tuples to records.
-- |
-- | We end up returning all data in the 'database' as an array of records.
getAll :: forall r. State -> { |r } -> Aff (Array Quote)
getAll st _ = map tupleToRecord <<< Map.toUnfoldable <$> AffVar.read st
  where
    tupleToRecord :: Tuple Int String -> Quote
    tupleToRecord (Tuple id text) = {id, text}

