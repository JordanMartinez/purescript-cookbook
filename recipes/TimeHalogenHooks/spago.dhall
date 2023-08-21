{ name = "TimeHalogenHooks"
, dependencies =
  [ "aff"
  , "effect"
  , "halogen"
  , "halogen-hooks"
  , "halogen-subscriptions"
  , "integers"
  , "interpolate"
  , "js-date"
  , "maybe"
  , "prelude"
  , "tailrec"
  , "tuples"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/TimeHalogenHooks/src/**/*.purs" ]
}
