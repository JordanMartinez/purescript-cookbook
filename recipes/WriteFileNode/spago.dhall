{ name = "WriteFileNode"
, dependencies =
  [ "aff"
  , "console"
  , "effect"
  , "node-buffer"
  , "node-fs-aff"
  , "prelude"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/WriteFileNode/src/**/*.purs" ]
}
