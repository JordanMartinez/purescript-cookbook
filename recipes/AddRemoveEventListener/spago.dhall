{ name = "AddRemoveEventListener"
, dependencies =
  [ "console"
  , "effect"
  , "interpolate"
  , "psci-support"
  , "web-dom"
  , "web-events"
  , "web-html"
  , "web-uievents"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/AddRemoveEventListener/src/**/*.purs" ]
}
