{ name = "SignalRenderJs"
, dependencies =
  [ "console"
  , "effect"
  , "exceptions"
  , "maybe"
  , "prelude"
  , "signal"
  , "web-dom"
  , "web-html"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/SignalRenderJs/src/**/*.purs" ]
}
