{ name = "DiceCLI"
, dependencies =
  [ "console", "effect", "node-readline", "prelude", "random" ]
, packages = ../../packages.dhall
, sources = [ "recipes/DiceCLI/src/**/*.purs" ]
}
