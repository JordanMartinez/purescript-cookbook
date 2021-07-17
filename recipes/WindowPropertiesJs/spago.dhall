{ name = "WindowPropertiesJs"
, dependencies =
  [ "console"
  , "effect"
  , "interpolate"
  , "maybe"
  , "prelude"
  , "psci-support"
  , "web-html"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/WindowPropertiesJs/src/**/*.purs" ]
}
