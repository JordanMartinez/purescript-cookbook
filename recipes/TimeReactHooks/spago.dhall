{ name = "TimeReactHooks"
, dependencies =
  [ "arrays"
  , "console"
  , "effect"
  , "exceptions"
  , "integers"
  , "js-date"
  , "js-timers"
  , "maybe"
  , "newtype"
  , "prelude"
  , "psci-support"
  , "react-basic-dom"
  , "react-basic-hooks"
  , "web-html"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/TimeReactHooks/src/**/*.purs" ]
}
