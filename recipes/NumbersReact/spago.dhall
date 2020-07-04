{ name = "NumbersReact"
, dependencies =
  [ "console"
  , "effect"
  , "psci-support"
  , "random"
  , "react-basic-hooks"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/NumbersReact/src/**/*.purs" ]
}
