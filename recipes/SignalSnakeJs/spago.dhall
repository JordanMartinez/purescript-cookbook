{ name = "SignalSnakeJs"
, dependencies =
  [ "canvas"
  , "colors"
  , "console"
  , "effect"
  , "monad-loops"
  , "psci-support"
  , "quickcheck"
  , "signal"
  , "web-html"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/SignalSnakeJs/src/**/*.purs" ]
}
