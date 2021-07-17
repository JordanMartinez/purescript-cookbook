{ name = "HelloLog"
, dependencies = [ "console", "effect", "prelude", "psci-support" ]
, packages = ../../packages.dhall
, sources = [ "recipes/HelloLog/src/**/*.purs" ]
}
