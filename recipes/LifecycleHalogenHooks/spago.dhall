{ name = "LifecycleHalogenHooks"
, dependencies =
  [ "console"
  , "effect"
  , "halogen-hooks"
  , "psci-support"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/LifecycleHalogenHooks/src/**/*.purs" ]
}
