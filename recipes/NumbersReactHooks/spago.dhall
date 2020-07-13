{ name = "NumbersReactHooks"
, dependencies =
  [ "console"
  , "effect"
  , "psci-support"
  , "random"
  , "react-basic-hooks"
  , "react-basic-dom"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/NumbersReactHooks/src/**/*.purs" ]
}
