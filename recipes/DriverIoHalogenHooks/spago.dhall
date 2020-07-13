{ name = "DriverIoHalogenHooks"
, dependencies =
  [ "console"
  , "effect"
  , "halogen-hooks"
  , "halogen-hooks-extra"
  , "psci-support"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/DriverIoHalogenHooks/src/**/*.purs" ]
}
