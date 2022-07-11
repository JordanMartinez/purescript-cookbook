{ name = "InterpretHalogenHooks"
, dependencies =
  [ "aff"
  , "affjax"
  , "affjax-web"
  , "console"
  , "effect"
  , "either"
  , "halogen"
  , "halogen-hooks"
  , "maybe"
  , "prelude"
  , "transformers"
  , "tuples"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/InterpretHalogenHooks/src/**/*.purs" ]
}
