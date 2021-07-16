{ name = "RoutingHashReactHooks"
, dependencies =
  [ "console"
  , "effect"
  , "psci-support"
  , "react-basic-dom"
  , "react-basic-hooks"
  , "routing"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/RoutingHashReactHooks/src/**/*.purs" ]
}
