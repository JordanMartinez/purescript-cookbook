{ name = "PositionsReact"
, dependencies =
  [ "console"
  , "effect"
  , "psci-support"
  , "random"
  , "react-basic-hooks"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/PositionsReact/src/**/*.purs" ]
}
