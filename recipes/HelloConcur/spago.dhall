{ name = "HelloConcur"
, dependencies =
  [ "concur-react", "console", "effect", "prelude", "psci-support" ]
, packages = ../../packages.dhall
, sources = [ "recipes/HelloConcur/src/**/*.purs" ]
}
