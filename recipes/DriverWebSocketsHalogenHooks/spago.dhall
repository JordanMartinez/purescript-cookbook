{ name = "DriverWebSocketsHalogenHooks"
, dependencies =
  [ "console"
  , "effect"
  , "halogen-hooks"
  , "psci-support"
  , "aff-coroutines"
  , "web-socket"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/DriverWebSocketsHalogenHooks/src/**/*.purs" ]
}
