{ name = "BasicHalogenHooks"
, dependencies =
  [ "console"
  , "effect"
  , "halogen"
  , "halogen-hooks"
  , "maybe"
  , "prelude"
  , "psci-support"
  , "tuples"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/BasicHalogenHooks/src/**/*.purs" ]
}
