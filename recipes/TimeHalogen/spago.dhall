{ name = "TimeHalogen"
, dependencies =
  [ "console"
  , "effect"
  , "halogen-hooks"
  , "interpolate"
  , "psci-support"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/TimeHalogen/src/**/*.purs" ]
}
