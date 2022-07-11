{ name = "DebuggingLog"
, dependencies =
  [ "aff"
  , "console"
  , "debug"
  , "effect"
  , "prelude"
  , "st"
  , "tuples"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/DebuggingLog/src/**/*.purs" ]
}
