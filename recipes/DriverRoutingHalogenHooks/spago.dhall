{ name = "DriverRoutingHalogenHooks"
, dependencies =
  [ "console"
  , "effect"
  , "halogen-hooks"
  , "psci-support"
  , "aff-coroutines"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/DriverRoutingHalogenHooks/src/**/*.purs" ]
}
