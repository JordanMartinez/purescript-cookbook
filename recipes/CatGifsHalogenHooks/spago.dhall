{ name = "CatGifsHalogenHooks"
, dependencies =
  [ "aff"
  , "affjax"
  , "affjax-web"
  , "argonaut-core"
  , "codec"
  , "codec-argonaut"
  , "console"
  , "css"
  , "effect"
  , "either"
  , "halogen"
  , "halogen-css"
  , "halogen-hooks"
  , "http-methods"
  , "interpolate"
  , "maybe"
  , "prelude"
  , "psci-support"
  , "remotedata"
  , "tuples"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/CatGifsHalogenHooks/src/**/*.purs" ]
}
