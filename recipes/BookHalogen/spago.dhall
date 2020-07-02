{ name = "BookHalogen"
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
, sources = [ "recipes/BookHalogen/src/**/*.purs" ]
}
