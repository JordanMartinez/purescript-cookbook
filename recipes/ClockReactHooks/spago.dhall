{ name = "ClockReactHooks"
, dependencies =
  [ "console"
  , "effect"
  , "exceptions"
  , "js-date"
  , "js-timers"
  , "maybe"
  , "newtype"
  , "numbers"
  , "prelude"
  , "psci-support"
  , "react-basic-dom"
  , "react-basic-hooks"
  , "web-html"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/ClockReactHooks/src/**/*.purs" ]
}
