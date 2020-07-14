{ name = "HeterogenousArrayLog"
, dependencies =
  [ "console", "effect", "psci-support", "variant", "arrays" ]
, packages = ../../packages.dhall
, sources = [ "recipes/HeterogenousArrayLog/src/**/*.purs" ]
}
{-
sources does not work with paths relative to this config
  sources = [ "src/**/*.purs" ]
Paths must be relative to where this command is run
-}
