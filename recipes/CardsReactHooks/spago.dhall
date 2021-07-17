{ name = "CardsReactHooks"
, dependencies =
  [ "arrays"
  , "console"
  , "effect"
  , "exceptions"
  , "maybe"
  , "nonempty"
  , "prelude"
  , "psci-support"
  , "quickcheck"
  , "react-basic"
  , "react-basic-dom"
  , "react-basic-hooks"
  , "web-html"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/CardsReactHooks/src/**/*.purs" ]
}
