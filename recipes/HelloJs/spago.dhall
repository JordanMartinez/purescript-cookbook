{ name = "HelloJs"
, dependencies =
  [ "console"
  , "effect"
  , "exceptions"
  , "maybe"
  , "prelude"
  , "web-dom"
  , "web-html"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/HelloJs/src/**/*.purs" ]
}
