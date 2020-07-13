{ name = "TimeHalogenHooks"
, dependencies =
  [ "console"
  , "effect"
  , "halogen-hooks"
  , "js-date"
  , "interpolate"
  , "psci-support"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/TimeHalogenHooks/src/**/*.purs" ]
}
