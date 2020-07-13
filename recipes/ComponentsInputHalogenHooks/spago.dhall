{ name = "ComponentsInputHalogenHooks"
, dependencies =
  [ "console"
  , "effect"
  , "halogen-hooks"
  , "halogen-hooks-extra"
  , "psci-support"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/ComponentsInputHalogenHooks/src/**/*.purs" ]
}
