{ name = "ReadPrintFileContents"
, dependencies = [ "console", "effect", "node-fs-aff", "psci-support" ]
, packages = ../../packages.dhall
, sources = [ "recipes/ReadPrintFileContents/src/**/*.purs" ]
}
