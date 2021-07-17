{ name = "DiceCLI"
, dependencies =
  [ "console", "effect", "node-readline", "prelude", "psci-support", "random" ]
, packages = ../../packages.dhall
, sources = [ "recipes/DiceCLI/src/**/*.purs" ]
}
