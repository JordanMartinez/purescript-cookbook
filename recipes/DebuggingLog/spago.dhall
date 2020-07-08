{ name = "DebuggingLog"
, dependencies =
  [ "aff", "console", "debug", "effect", "psci-support", "random", "st" ]
, packages = ../../packages.dhall
, sources = [ "recipes/DebuggingLog/src/**/*.purs" ]
}
