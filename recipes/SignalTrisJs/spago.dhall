{ name = "SignalTrisJs"
, dependencies =
  [ "arrays"
  , "canvas"
  , "colors"
  , "control"
  , "effect"
  , "exceptions"
  , "foldable-traversable"
  , "heterogeneous"
  , "integers"
  , "lcg"
  , "maybe"
  , "ordered-collections"
  , "prelude"
  , "quickcheck"
  , "signal"
  , "tuples"
  , "web-dom"
  , "web-html"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/SignalTrisJs/src/**/*.purs" ]
}
