{ name = "DebuggingLog"
, dependencies =
  [ "aff"
  , "console"
  , "debug"
  , "effect"
  , "prelude"
  , "psci-support"
  , "st"
  , "tuples"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/DebuggingLog/src/**/*.purs" ]
}
