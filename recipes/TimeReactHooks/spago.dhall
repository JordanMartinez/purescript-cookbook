{ name = "TimeReactHooks"
, dependencies =
  [ "console"
  , "datetime"
  , "effect"
  , "js-date"
  , "js-timers"
  , "now"
  , "psci-support"
  , "react-basic-hooks"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/TimeReactHooks/src/**/*.purs" ]
}
