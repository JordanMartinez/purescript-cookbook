{ name = "DebuggingLog"
, dependencies =
  [ "aff", "console", "debug", "effect", "psci-support", "st" ]
, packages = ../../packages.dhall
, sources = [ "recipes/DebuggingLog/src/**/*.purs" ]
}
