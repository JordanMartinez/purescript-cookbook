{ name = "ButtonsReact"
, dependencies =
  [ "console"
  , "effect"
  , "psci-support"
  , "react-basic-hooks"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/ButtonsReact/src/**/*.purs" ]
}
