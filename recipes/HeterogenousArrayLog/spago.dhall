{ name = "HeterogenousArrayLog"
, dependencies =
  [ "arrays", "console", "effect", "prelude", "psci-support", "variant" ]
, packages = ../../packages.dhall
, sources = [ "recipes/HeterogenousArrayLog/src/**/*.purs" ]
}
