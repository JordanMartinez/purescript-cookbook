{ name = "DateTimeBasicsLog"
, dependencies =
  [ "bifunctors"
  , "console"
  , "datetime"
  , "effect"
  , "enums"
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
, sources = [ "recipes/DateTimeBasicsLog/src/**/*.purs" ]
}
