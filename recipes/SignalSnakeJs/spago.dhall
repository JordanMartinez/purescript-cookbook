{ name = "SignalSnakeJs"
, dependencies =
  [ "arrays"
  , "canvas"
  , "colors"
  , "console"
  , "control"
  , "effect"
  , "exceptions"
  , "foldable-traversable"
  , "integers"
  , "lcg"
  , "maybe"
  , "monad-loops"
  , "prelude"
  , "psci-support"
  , "quickcheck"
  , "signal"
  , "tuples"
  , "web-dom"
  , "web-html"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/SignalSnakeJs/src/**/*.purs" ]
}
