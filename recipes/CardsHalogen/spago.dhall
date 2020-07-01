{ name = "CardsHalogen"
, dependencies =
  [ "console"
  , "effect"
  , "halogen-css"
  , "halogen-hooks"
  , "psci-support"
  , "random"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/CardsHalogen/src/**/*.purs" ]
}
