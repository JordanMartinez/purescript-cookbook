{ name = "ComponentsReactHooks"
, dependencies =
  [ "effect"
  , "exceptions"
  , "maybe"
  , "prelude"
  , "react-basic"
  , "react-basic-dom"
  , "react-basic-hooks"
  , "web-html"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/ComponentsReactHooks/src/**/*.purs" ]
}
