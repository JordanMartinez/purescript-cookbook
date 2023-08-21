{ name = "DriverWebSocketsHalogenHooks"
, dependencies =
  [ "aff"
  , "arrays"
  , "effect"
  , "either"
  , "foreign"
  , "halogen"
  , "halogen-hooks"
  , "halogen-subscriptions"
  , "maybe"
  , "prelude"
  , "transformers"
  , "tuples"
  , "web-events"
  , "web-socket"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/DriverWebSocketsHalogenHooks/src/**/*.purs" ]
}
