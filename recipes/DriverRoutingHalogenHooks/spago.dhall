{ name = "DriverRoutingHalogenHooks"
, dependencies =
  [ "aff"
  , "aff-coroutines"
  , "arrays"
  , "coroutines"
  , "effect"
  , "foldable-traversable"
  , "halogen"
  , "halogen-hooks"
  , "maybe"
  , "prelude"
  , "strings"
  , "tuples"
  , "web-events"
  , "web-html"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/DriverRoutingHalogenHooks/src/**/*.purs" ]
}
