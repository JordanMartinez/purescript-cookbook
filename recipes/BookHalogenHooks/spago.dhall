{ name = "BookHalogenHooks"
, dependencies =
  [ "aff"
  , "affjax"
  , "affjax-web"
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
