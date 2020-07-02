{ name = "CatGIFsHalogen"
, dependencies =
  [ "console"
  , "effect"
  , "halogen-hooks"
  , "interpolate"
  , "psci-support"
  , "remotedata"
  , "affjax"
  , "codec"
  , "codec-argonaut"
  , "halogen-css"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/CatGIFsHalogen/src/**/*.purs" ]
}
