{ name = "CatGifsReact"
, dependencies =
  [ "affjax"
  , "argonaut-codecs"
  , "console"
  , "effect"
  , "psci-support"
  , "react-basic-hooks"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/CatGifsReact/src/**/*.purs" ]
}
