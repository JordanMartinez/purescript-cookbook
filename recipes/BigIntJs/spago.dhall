{ name = "BigIntJs"
, dependencies =
  [ "bigints"
  , "console"
  , "effect"
  , "integers"
  , "maybe"
  , "partial"
  , "prelude"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/BigIntJs/src/**/*.purs" ]
}
