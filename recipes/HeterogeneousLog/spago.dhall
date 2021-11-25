{ name = "HeterogeneousLog"
, dependencies =
  [ "console"
  , "effect"
  , "heterogeneous"
  , "maybe"
  , "prelude"
  , "psci-support"
  , "record"
  , "tuples"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/HeterogeneousLog/src/**/*.purs" ]
}
