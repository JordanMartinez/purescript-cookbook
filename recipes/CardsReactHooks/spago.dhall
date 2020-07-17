{ name = "CardsReactHooks"
, dependencies =
  [ "console"
  , "effect"
  , "nonempty"
  , "psci-support"
  , "quickcheck"
  , "react-basic-hooks"
  , "react-basic-dom"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/CardsReactHooks/src/**/*.purs" ]
}
