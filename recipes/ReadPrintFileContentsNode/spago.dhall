{ name = "ReadPrintFileContentsNode"
, dependencies = [ "console", "effect", "node-fs-aff", "psci-support" ]
, packages = ../../packages.dhall
, sources = [ "recipes/ReadPrintFileContentsNode/src/**/*.purs" ]
}
