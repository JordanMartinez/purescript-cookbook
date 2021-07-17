{ name = "BookReactHooks"
, dependencies =
  [ "affjax"
  , "console"
  , "effect"
  , "either"
  , "exceptions"
  , "maybe"
  , "prelude"
  , "psci-support"
  , "react-basic-dom"
  , "react-basic-hooks"
  , "web-html"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/BookReactHooks/src/**/*.purs" ]
}
