{ name = "BookHalogenHooks"
, dependencies =
  [ "console"
  , "effect"
  , "halogen-hooks"
  , "interpolate"
  , "psci-support"
  , "remotedata"
  , "affjax"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/BookHalogenHooks/src/**/*.purs" ]
}
