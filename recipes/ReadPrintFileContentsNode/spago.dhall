{ name = "ReadPrintFileContentsNode"
, dependencies =
  [ "aff"
  , "console"
  , "effect"
  , "node-buffer"
  , "node-fs-aff"
  , "prelude"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/ReadPrintFileContentsNode/src/**/*.purs" ]
}
