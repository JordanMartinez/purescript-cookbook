{ name = "RunCapabilityPatternNode"
, dependencies =
  [ "aff"
  , "assert"
  , "console"
  , "effect"
  , "node-fs"
  , "node-fs-aff"
  , "node-readline"
  , "transformers"
  , "run"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/RunCapabilityPatternNode/src/**/*.purs" ]
}
