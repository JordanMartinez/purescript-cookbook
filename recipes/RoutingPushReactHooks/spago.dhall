{ name = "RoutingPushReactHooks"
, dependencies =
  [ "arrays"
  , "console"
  , "effect"
  , "exceptions"
  , "foldable-traversable"
  , "foreign"
  , "maybe"
  , "partial"
  , "prelude"
  , "psci-support"
  , "react-basic"
  , "react-basic-dom"
  , "react-basic-hooks"
  , "routing"
  , "transformers"
  , "web-html"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/RoutingPushReactHooks/src/**/*.purs" ]
}
