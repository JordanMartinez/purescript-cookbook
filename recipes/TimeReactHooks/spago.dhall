{ name = "TimeReactHooks"
, dependencies =
  [ "console"
  , "datetime"
  , "effect"
  , "js-timers"
  , "now"
  , "psci-support"
  , "react-basic-hooks"
  , "react-basic-dom"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/TimeReactHooks/src/**/*.purs" ]
}
