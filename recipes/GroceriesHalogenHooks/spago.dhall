{ name = "GroceriesHalogenHooks"
, dependencies =
  [ "console"
  , "effect"
  , "halogen"
  , "halogen-hooks"
  , "maybe"
  , "prelude"
  , "psci-support"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/GroceriesHalogenHooks/src/**/*.purs" ]
}
