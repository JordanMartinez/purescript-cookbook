{ name = "PositionsReactHooks"
, dependencies =
  [ "console"
  , "effect"
  , "psci-support"
  , "random"
  , "react-basic-hooks"
  , "react-basic-dom"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/PositionsReactHooks/src/**/*.purs" ]
}
