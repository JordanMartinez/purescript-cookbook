{ name = "RandomNumberGameNode"
, dependencies =
  [ "aff"
  , "arrays"
  , "console"
  , "effect"
  , "either"
  , "integers"
  , "interpolate"
  , "maybe"
  , "node-readline"
  , "prelude"
  , "random"
  , "refs"
  , "transformers"
  , "type-equality"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/RandomNumberGameNode/src/**/*.purs" ]
}
