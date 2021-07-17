{ name = "BookHalogenHooks"
, dependencies =
  [ "aff"
  , "affjax"
  , "console"
  , "effect"
  , "either"
  , "halogen"
  , "halogen-hooks"
  , "http-methods"
  , "interpolate"
  , "maybe"
  , "prelude"
  , "psci-support"
  , "remotedata"
  , "tuples"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/BookHalogenHooks/src/**/*.purs" ]
}
