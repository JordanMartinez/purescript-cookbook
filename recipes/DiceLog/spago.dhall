{ name = "DiceLog"
, dependencies =
  [ "console", "effect", "psci-support", "random" ]
, packages = ../../packages.dhall
, sources = [ "recipes/DiceLog/src/**/*.purs" ]
}
{-
sources does not work with paths relative to this config
  sources = [ "src/**/*.purs" ]
Paths must be relative to where this command is run
-}
