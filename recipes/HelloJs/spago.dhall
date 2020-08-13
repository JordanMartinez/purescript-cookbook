{ name = "HelloJs"
, dependencies =
  [ "console", "effect", "psci-support", "web-html" ]
, packages = ../../packages.dhall
, sources = [ "recipes/HelloJs/src/**/*.purs" ]
}
