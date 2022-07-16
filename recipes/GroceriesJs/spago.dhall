{ name = "GroceriesJs"
, dependencies =
  [ "effect"
  , "exceptions"
  , "foldable-traversable"
  , "maybe"
  , "prelude"
  , "web-dom"
  , "web-html"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/GroceriesJs/src/**/*.purs" ]
}
