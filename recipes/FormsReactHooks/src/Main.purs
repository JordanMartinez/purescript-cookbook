module FormsReactHooks.Main where

import Prelude

import Data.Maybe (Maybe(..), fromMaybe)
import Effect (Effect)
import Effect.Exception (throw)
import React.Basic.DOM (css, render)
import React.Basic.DOM as R
import React.Basic.DOM.Events (preventDefault, targetValue)
import React.Basic.Events (EventHandler, handler)
import React.Basic.Hooks (type (/\), Component, Hook, UseState, component, useState, (/\))
import React.Basic.Hooks as React
import Web.HTML (window)
import Web.HTML.HTMLDocument (body)
import Web.HTML.HTMLElement (toElement)
import Web.HTML.Window (document)

main :: Effect Unit
main = do
  body <- body =<< document =<< window
  case body of
    Nothing -> throw "Could not find body."
    Just b -> do
      form <- mkForm
      render (form {}) (toElement b)

mkForm :: Component {}
mkForm = do
  component "Form" \_ -> React.do
    name /\ onNameChange <- useInput ""
    password /\ onPasswordChange <- useInput ""
    passwordAgain /\ onPasswordAgainChange <- useInput ""
    let
      renderValidation =
        if password == passwordAgain then
          R.div { style: css { color: "green" }, children: [ R.text "OK" ] }
        else
          R.div { style: css { color: "red" }, children: [ R.text "Passwords do not match!" ] }
    pure
      $ R.form
          { onSubmit: handler preventDefault mempty
          , children:
              [ R.input
                  { placeholder: "Name"
                  , value: name
                  , onChange: onNameChange
                  }
              , R.input
                  { type: "password"
                  , placeholder: "Password"
                  , value: password
                  , onChange: onPasswordChange
                  }
              , R.input
                  { type: "password"
                  , placeholder: "Re-enter Password"
                  , value: passwordAgain
                  , onChange: onPasswordAgainChange
                  }
              , renderValidation
              ]
          }

useInput
  :: String
  -> Hook
       (UseState String)
       (String /\ EventHandler)
useInput initialValue = React.do
  value /\ setValue <- useState initialValue
  let
    onChange = handler targetValue (setValue <<< const <<< fromMaybe "")
  pure (value /\ onChange)
