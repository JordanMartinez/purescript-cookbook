{ name = "CapabilityPatternWithCheckedExceptionsNode"
, dependencies =
  [ "aff"
  , "assert"
  , "console"
  , "effect"
  , "transformers"
  , "checked-exceptions"
  , "typelevel-prelude"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/CapabilityPatternWithCheckedExceptionsNode/src/**/*.purs" ]
}
