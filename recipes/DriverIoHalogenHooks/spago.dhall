{ name = "DriverIoHalogenHooks"
, dependencies =
  [ "console"
  , "effect"
  , "halogen"
  , "halogen-hooks"
  , "halogen-subscriptions"
  , "maybe"
  , "prelude"
  , "tuples"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/DriverIoHalogenHooks/src/**/*.purs" ]
}
