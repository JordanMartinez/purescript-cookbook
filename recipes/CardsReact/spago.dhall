{ name = "CardsReact"
, dependencies =
  [ "console"
  , "effect"
  , "psci-support"
  , "react-basic-hooks"
  , "random"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/CardsReact/src/**/*.purs" ]
}
