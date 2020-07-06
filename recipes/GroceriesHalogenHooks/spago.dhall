{ name = "GroceriesHalogenHooks"
, dependencies =
  [ "console"
  , "effect"
  , "halogen-hooks"
  , "psci-support"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/GroceriesHalogenHooks/src/**/*.purs" ]
}
