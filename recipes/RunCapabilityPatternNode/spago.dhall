{ name = "RunCapabilityPatternNode"
, dependencies =
  [ "aff"
  , "assert"
  , "console"
  , "effect"
  , "node-buffer"
  , "node-fs"
  , "node-fs-aff"
  , "prelude"
  , "run"
  , "typelevel-prelude"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/RunCapabilityPatternNode/src/**/*.purs" ]
}
