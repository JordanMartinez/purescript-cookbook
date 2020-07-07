{ name = "HelloReactHooks"
, dependencies =
  [ "console"
  , "effect"
  , "psci-support"
  , "react-basic-hooks"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/HelloReactHooks/src/**/*.purs" ]
}
