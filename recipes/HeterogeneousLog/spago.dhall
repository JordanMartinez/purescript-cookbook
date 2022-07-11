{ name = "HeterogeneousLog"
, dependencies =
  [ "console"
  , "effect"
  , "heterogeneous"
  , "maybe"
  , "prelude"
  , "record"
  , "tuples"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/HeterogeneousLog/src/**/*.purs" ]
}
