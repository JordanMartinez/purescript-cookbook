{ name = "RoutingHashLog"
, dependencies =
  [ "console", "effect", "psci-support", "routing" ]
, packages = ../../packages.dhall
, sources = [ "recipes/RoutingHashLog/src/**/*.purs" ]
}
