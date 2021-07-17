{ name = "BigIntJs"
, dependencies =
  [ "bigints"
  , "console"
  , "effect"
  , "integers"
  , "maybe"
  , "partial"
  , "prelude"
  , "psci-support"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/BigIntJs/src/**/*.purs" ]
}
