{ name = "PayloadHttpApiNode"
, dependencies =
  [ "aff"
  , "avar"
  , "console"
  , "effect"
  , "either"
  , "maybe"
  , "ordered-collections"
  , "payload"
  , "prelude"
  , "tuples"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/PayloadHttpApiNode/src/**/*.purs" ]
}
