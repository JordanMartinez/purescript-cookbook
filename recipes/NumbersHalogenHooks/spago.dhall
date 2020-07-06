{ name = "NumbersHalogenHooks"
, dependencies =
  [ "console", "effect", "psci-support", "random", "halogen-hooks" ]
, packages = ../../packages.dhall
, sources = [ "recipes/NumbersHalogenHooks/src/**/*.purs" ]
}
{-
sources does not work with paths relative to this config
  sources = [ "src/**/*.purs" ]
Paths must be relative to where this command is run
-}
