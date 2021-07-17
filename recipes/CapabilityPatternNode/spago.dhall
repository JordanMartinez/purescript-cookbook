{ name = "CapabilityPatternNode"
, dependencies =
  [ "aff"
  , "assert"
  , "console"
  , "effect"
  , "node-buffer"
  , "node-fs"
  , "node-fs-aff"
  , "node-readline"
  , "prelude"
  , "transformers"
  , "type-equality"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/CapabilityPatternNode/src/**/*.purs" ]
}
