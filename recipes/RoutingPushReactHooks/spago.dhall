{ name = "RoutingPushReactHooks"
, dependencies =
  [ "console"
  , "effect"
  , "generics-rep"
  , "psci-support"
  , "react-basic-dom"
  , "react-basic-hooks"
  , "routing"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/RoutingPushReactHooks/src/**/*.purs" ]
}
