{ name = "InterpretHalogenHooks"
, dependencies =
  [ "aff"
  , "affjax"
  , "console"
  , "effect"
  , "either"
  , "halogen"
  , "halogen-hooks"
  , "maybe"
  , "prelude"
  , "psci-support"
  , "transformers"
  , "tuples"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/InterpretHalogenHooks/src/**/*.purs" ]
}
