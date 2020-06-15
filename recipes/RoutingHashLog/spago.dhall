{ name = "RoutingHashLog"
, dependencies =
  [ "console", "effect", "generics-rep", "psci-support", "routing" ]
, packages = ../../packages.dhall
, sources = [ "recipes/RoutingHashLog/src/**/*.purs" ]
}
