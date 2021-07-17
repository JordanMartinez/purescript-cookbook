{ name = "ComponentsMultiTypeReactHooks"
, dependencies =
  [ "console"
  , "effect"
  , "exceptions"
  , "maybe"
  , "prelude"
  , "psci-support"
  , "react-basic"
  , "react-basic-dom"
  , "react-basic-hooks"
  , "tuples"
  , "web-html"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/ComponentsMultiTypeReactHooks/src/**/*.purs" ]
}
