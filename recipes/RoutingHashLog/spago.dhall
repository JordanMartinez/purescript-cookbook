{ name = "RoutingHashLog"
, dependencies =
  [ "console"
  , "effect"
  , "foldable-traversable"
  , "prelude"
  , "routing"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/RoutingHashLog/src/**/*.purs" ]
}
