{ name = "RoutingHashLog"
, dependencies =
  [ "console"
  , "effect"
  , "foldable-traversable"
  , "prelude"
  , "psci-support"
  , "routing"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/RoutingHashLog/src/**/*.purs" ]
}
