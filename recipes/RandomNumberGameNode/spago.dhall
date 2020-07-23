{ name = "RandomNumberGameNode"
, dependencies =
  [ "aff"
  , "console"
  , "effect"
  , "interpolate"
  , "node-readline"
  , "psci-support"
  , "random"
  , "transformers"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/RandomNumberGameNode/src/**/*.purs" ]
}
