{ name = "DiceCLI"
, dependencies =
  [ "console", "effect", "node-readline", "psci-support", "random" ]
, packages = ../../packages.dhall
, sources = [ "recipes/DiceCLI/src/**/*.purs" ]
}
{-
sources does not work with paths relative to this config
  sources = [ "src/**/*.purs" ]
Paths must be relative to where this command is run
-}
