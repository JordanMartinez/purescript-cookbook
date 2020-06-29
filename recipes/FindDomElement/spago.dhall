{ name = "FindDomElement"
, dependencies =
  [ "console"
  , "effect"
  , "interpolate"
  , "psci-support"
  , "web-dom"
  , "web-html"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/FindDomElement/src/**/*.purs" ]
}
