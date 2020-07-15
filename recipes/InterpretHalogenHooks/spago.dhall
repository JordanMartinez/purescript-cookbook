{ name = "InterpretHalogenHooks"
, dependencies =
  [ "console"
  , "effect"
  , "halogen-hooks"
  , "psci-support"
  , "affjax"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/InterpretHalogenHooks/src/**/*.purs" ]
}
