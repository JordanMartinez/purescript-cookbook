{ name = "CardsReact"
, dependencies =
  [ "console"
  , "effect"
  , "nonempty"
  , "psci-support"
  , "quickcheck"
  , "react-basic-hooks"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/CardsReact/src/**/*.purs" ]
}
