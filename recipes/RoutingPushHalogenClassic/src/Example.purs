module RoutingPushHalogenClassic.Example where

import Prelude
import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import RoutingPushHalogenClassic.MyRouting (MyRoute)

type State
  = Maybe MyRoute

-- Query must be (Type -> Type)
data Query a
  = Nav MyRoute a

component :: forall i o m. H.Component HH.HTML Query i o m
component =
  H.mkComponent
    { initialState: const Nothing
    , render
    , eval:
        H.mkEval
          $ H.defaultEval
              { handleQuery = handleQuery
              }
    }

render :: forall a m. State -> H.ComponentHTML a () m
render state =
  let
    renderLink link txt = HH.div_ [ HH.a [ HP.href link ] [ HH.text txt ] ]
  in
    HH.div_
      [ HH.text $ show state
      , renderLink "/posts/" "Index"
      , renderLink "/posts/8" "View post 8"
      , renderLink "/posts/8/edit" "Edit post 8"
      , renderLink "/posts/browse/2004/June" "Browse 2004 June"
      , renderLink "/posts/?b=2&a=1" "Set 'a' and 'b' query parameters"
      ]

handleQuery ∷ forall a ac o m. Query a → H.HalogenM State ac () o m (Maybe a)
handleQuery (Nav route a) = do
  H.put $ Just route
  pure (Just a)
