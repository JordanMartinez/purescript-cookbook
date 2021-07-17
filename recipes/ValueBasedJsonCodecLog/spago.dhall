{ name = "ValueBasedJsonCodecLog"
, dependencies =
  [ "argonaut-core"
  , "bifunctors"
  , "codec"
  , "codec-argonaut"
  , "console"
  , "effect"
  , "either"
  , "foldable-traversable"
  , "integers"
  , "maybe"
  , "partial"
  , "prelude"
  , "profunctor"
  , "psci-support"
  , "strings"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/ValueBasedJsonCodecLog/src/**/*.purs" ]
}
