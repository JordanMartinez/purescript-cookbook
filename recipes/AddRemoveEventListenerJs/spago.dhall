{ name = "AddRemoveEventListenerJs"
, dependencies =
  [ "console"
  , "effect"
  , "interpolate"
  , "maybe"
  , "prelude"
  , "psci-support"
  , "refs"
  , "unsafe-coerce"
  , "web-dom"
  , "web-events"
  , "web-html"
  , "web-uievents"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/AddRemoveEventListenerJs/src/**/*.purs" ]
}
