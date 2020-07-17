{ name = "HelloReactHooks"
, dependencies =
  [ "console"
  , "effect"
  , "psci-support"
  , "react-basic-hooks"
  , "react-basic-dom"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/HelloReactHooks/src/**/*.purs" ]
}
