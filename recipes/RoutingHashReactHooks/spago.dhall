{ name = "RoutingHashReactHooks"
, dependencies =
  [ "arrays"
  , "console"
  , "effect"
  , "exceptions"
  , "foldable-traversable"
  , "maybe"
  , "prelude"
  , "psci-support"
  , "react-basic"
  , "react-basic-dom"
  , "react-basic-hooks"
  , "routing"
  , "strings"
  , "web-html"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/RoutingHashReactHooks/src/**/*.purs" ]
}
