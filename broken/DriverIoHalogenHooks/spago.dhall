{ name = "DriverIoHalogenHooks"
, dependencies =
  [ "console"
  , "effect"
  , "halogen-hooks"
  , "psci-support"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/DriverIoHalogenHooks/src/**/*.purs" ]
}
