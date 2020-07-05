{ name = "BookReact"
, dependencies =
  [ "affjax"
  , "console"
  , "effect"
  , "psci-support"
  , "react-basic-hooks"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/BookReact/src/**/*.purs" ]
}
