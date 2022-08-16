{ name = "ClockReactHooks"
, dependencies =
  [ "effect"
  , "exceptions"
  , "js-date"
  , "js-timers"
  , "maybe"
  , "newtype"
  , "numbers"
  , "prelude"
  , "react-basic-dom"
  , "react-basic-hooks"
  , "web-dom"
  , "web-html"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/ClockReactHooks/src/**/*.purs" ]
}
