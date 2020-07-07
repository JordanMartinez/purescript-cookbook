{ name = "CardsHalogenHooks"
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
, sources = [ "recipes/CardsHalogenHooks/src/**/*.purs" ]
}
