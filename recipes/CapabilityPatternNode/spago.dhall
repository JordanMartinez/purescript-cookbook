{ name = "CapabilityPatternNode"
, dependencies =
  [ "aff"
  , "assert"
  , "console"
  , "effect"
  , "node-fs"
  , "node-fs-aff"
  , "node-readline"
  , "transformers"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/CapabilityPatternNode/src/**/*.purs" ]
}
