{ name = "WriteFileNode"
, dependencies = [ "console", "effect", "node-fs-aff", "psci-support" ]
, packages = ../../packages.dhall
, sources = [ "recipes/WriteFileNode/src/**/*.purs" ]
}
