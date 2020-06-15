{ name = "RoutingPushHalogen"
, dependencies =
  [ "console", "effect", "generics-rep", "halogen", "psci-support", "routing" ]
, packages = ../../packages.dhall
, sources = [ "recipes/RoutingPushHalogen/src/**/*.purs" ]
}
