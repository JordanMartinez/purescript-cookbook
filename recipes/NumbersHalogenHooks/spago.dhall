{ name = "NumbersHalogenHooks"
, dependencies =
  [ "console"
  , "effect"
  , "halogen"
  , "halogen-hooks"
  , "maybe"
  , "prelude"
  , "psci-support"
  , "random"
  , "tuples"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/NumbersHalogenHooks/src/**/*.purs" ]
}
