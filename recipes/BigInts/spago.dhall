{ name = "BigInts"
, dependencies =
  [ "console", "effect", "psci-support", "maybe", "bigints" ]
, packages = ../../packages.dhall
, sources = [ "recipes/BigInts/src/**/*.purs" ]
}
{-
sources does not work with paths relative to this config
  sources = [ "src/**/*.purs" ]
Paths must be relative to where this command is run
-}
