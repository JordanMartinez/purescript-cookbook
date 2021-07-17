{ name = "CatGifsReactHooks"
, dependencies =
  [ "aff"
  , "affjax"
  , "argonaut-codecs"
  , "console"
  , "effect"
  , "either"
  , "exceptions"
  , "maybe"
  , "prelude"
  , "psci-support"
  , "react-basic"
  , "react-basic-dom"
  , "react-basic-hooks"
  , "web-html"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/CatGifsReactHooks/src/**/*.purs" ]
}
