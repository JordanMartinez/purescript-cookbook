{ name = "BasicHalogenHooks"
, dependencies =
  [ "console"
  , "effect"
  , "halogen-hooks"
  , "psci-support"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/BasicHalogenHooks/src/**/*.purs" ]
}
