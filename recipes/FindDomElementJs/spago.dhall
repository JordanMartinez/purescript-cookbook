{ name = "FindDomElementJs"
, dependencies =
  [ "console"
  , "effect"
  , "foldable-traversable"
  , "interpolate"
  , "prelude"
  , "web-dom"
  , "web-html"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/FindDomElementJs/src/**/*.purs" ]
}
