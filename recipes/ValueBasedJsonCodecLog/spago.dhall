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
  , "strings"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/ValueBasedJsonCodecLog/src/**/*.purs" ]
}
