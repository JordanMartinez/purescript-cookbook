{ name = "BookReactHooks"
, dependencies =
  [ "affjax"
  , "console"
  , "effect"
  , "psci-support"
  , "react-basic-hooks"
  , "react-basic-dom"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/BookReactHooks/src/**/*.purs" ]
}
