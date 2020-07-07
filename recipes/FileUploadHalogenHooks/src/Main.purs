module FileUploadHalogenHooks.Main where

import Prelude

import Data.Tuple.Nested ((/\))
import DOM.HTML.Indexed.InputType (InputType(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.Hooks as Hooks
import Halogen.VDom.Driver (runUI)
import Web.File.File as File

main :: Effect Unit
main =
  HA.runHalogenAff do
    body <- HA.awaitBody
    void $ runUI hookComponent Nothing body

hookComponent
  :: forall unusedQuery unusedInput unusedOutput anyMonad
   . H.Component HH.HTML unusedQuery unusedInput unusedOutput anyMonad
hookComponent = Hooks.component \_ _ -> Hooks.do
  files /\ filesIdx <- Hooks.useState []
  Hooks.pure $
    HH.div_
    [ HH.input
        [ HP.type_ InputFile
        , HP.multiple true
        , HE.onFileUpload \fileArray -> Just $ Hooks.put filesIdx fileArray
        ]
    , HH.div_ [ HH.text $ show $ map File.name files ]
    ]
