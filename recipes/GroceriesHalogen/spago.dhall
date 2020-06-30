{ name = "GroceriesHalogen"
, dependencies =
  [ "console"
  , "effect"
  , "halogen-hooks"
  , "psci-support"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/GroceriesHalogen/src/**/*.purs" ]
}
