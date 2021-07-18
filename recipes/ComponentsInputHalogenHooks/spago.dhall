{ name = "ComponentsInputHalogenHooks"
, dependencies =
  [ "console"
  , "effect"
  , "halogen"
  , "halogen-hooks"
  , "maybe"
  , "prelude"
  , "psci-support"
  , "refs"
  , "tuples"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/ComponentsInputHalogenHooks/src/**/*.purs" ]
}
