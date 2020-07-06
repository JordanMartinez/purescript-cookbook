{ name = "TimeHalogenHooks"
, dependencies =
  [ "console"
  , "effect"
  , "halogen-hooks"
  , "interpolate"
  , "psci-support"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/TimeHalogenHooks/src/**/*.purs" ]
}
