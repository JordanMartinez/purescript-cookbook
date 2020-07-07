{ name = "NumbersReactHooks"
, dependencies =
  [ "console"
  , "effect"
  , "psci-support"
  , "random"
  , "react-basic-hooks"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/NumbersReactHooks/src/**/*.purs" ]
}
