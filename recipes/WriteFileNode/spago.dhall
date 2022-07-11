{ name = "WriteFileNode"
, dependencies =
  [ "aff"
  , "effect"
  , "node-buffer"
  , "node-fs-aff"
  , "prelude"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/WriteFileNode/src/**/*.purs" ]
}
