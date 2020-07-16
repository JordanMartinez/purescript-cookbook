{ name = "HelloLog"
, dependencies =
  [ "console", "effect", "psci-support" ]
, packages = ../../packages.dhall
, sources = [ "recipes/HelloLog/src/**/*.purs" ]
}
{-
sources does not work with paths relative to this config
  sources = [ "src/**/*.purs" ]
Paths must be relative to where this command is run
-}
