{ name = "BookHalogenHooks"
, dependencies =
  [ "aff"
  , "affjax"
  , "affjax-web"
  , "effect"
  , "either"
  , "halogen"
  , "halogen-hooks"
  , "http-methods"
  , "maybe"
  , "prelude"
  , "remotedata"
  , "tuples"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/BookHalogenHooks/src/**/*.purs" ]
}
