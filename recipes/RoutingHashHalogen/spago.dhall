{ name = "RoutingHashHalogen"
, dependencies =
  [ "console", "effect", "generics-rep", "halogen", "psci-support", "routing" ]
, packages = ../../packages.dhall
, sources = [ "recipes/RoutingHashHalogen/src/**/*.purs" ]
}
