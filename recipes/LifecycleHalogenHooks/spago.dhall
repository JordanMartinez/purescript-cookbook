{ name = "LifecycleHalogenHooks"
, dependencies =
  [ "arrays"
  , "console"
  , "effect"
  , "halogen"
  , "halogen-hooks"
  , "maybe"
  , "prelude"
  , "psci-support"
  , "tuples"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/LifecycleHalogenHooks/src/**/*.purs" ]
}
