{ name = "FindDomElementJs"
, dependencies =
  [ "console"
  , "effect"
  , "foldable-traversable"
  , "interpolate"
  , "prelude"
  , "psci-support"
  , "web-dom"
  , "web-html"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/FindDomElementJs/src/**/*.purs" ]
}
