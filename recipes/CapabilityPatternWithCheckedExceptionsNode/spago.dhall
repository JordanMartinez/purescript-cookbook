{ name = "CapabilityPatternWithCheckedExceptionsNode"
, dependencies =
  [ "aff"
  , "assert"
  , "console"
  , "effect"
  , "node-fs"
  , "node-fs-aff"
  , "node-readline"
  , "transformers"
  , "checked-exceptions"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/CapabilityPatternWithCheckedExceptionsNode/src/**/*.purs" ]
}
