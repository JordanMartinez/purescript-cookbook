{ name = "ClockReactHooks"
, dependencies =
  [ "console"
  , "effect"
  , "js-date"
  , "js-timers"
  , "psci-support"
  , "react-basic-hooks"
  , "react-basic-dom"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/ClockReactHooks/src/**/*.purs" ]
}
