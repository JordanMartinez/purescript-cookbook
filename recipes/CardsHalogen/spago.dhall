{ name = "CardsHalogen"
, dependencies =
  [ "console"
  , "effect"
  , "halogen-css"
  , "halogen-hooks"
  , "nonempty"
  , "psci-support"
  , "quickcheck"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/CardsHalogen/src/**/*.purs" ]
}
