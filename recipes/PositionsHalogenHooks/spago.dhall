{ name = "PositionsHalogenHooks"
, dependencies =
  [ "console", "effect", "psci-support", "random", "halogen-hooks", "halogen-css" ]
, packages = ../../packages.dhall
, sources = [ "recipes/PositionsHalogenHooks/src/**/*.purs" ]
}
{-
sources does not work with paths relative to this config
  sources = [ "src/**/*.purs" ]
Paths must be relative to where this command is run
-}
