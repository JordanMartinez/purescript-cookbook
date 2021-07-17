{ name = "ReadPrintFileContentsNode"
, dependencies =
  [ "aff"
  , "console"
  , "effect"
  , "node-buffer"
  , "node-fs-aff"
  , "prelude"
  , "psci-support"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/ReadPrintFileContentsNode/src/**/*.purs" ]
}
