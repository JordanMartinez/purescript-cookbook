{ name = "CapabilityPatternNode"
, dependencies =
  [ "aff"
  , "assert"
  , "console"
  , "effect"
  , "node-buffer"
  , "node-fs"
  , "node-fs-aff"
  , "prelude"
  , "transformers"
  , "type-equality"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/CapabilityPatternNode/src/**/*.purs" ]
}
