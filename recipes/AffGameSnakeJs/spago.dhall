{ name = "AffGameSnakeJs"
, dependencies =
  [ "canvas"
  , "canvas-action"
  , "colors"
  , "console"
  , "effect"
  , "game"
  , "monad-loops"
  , "polymorphic-vectors"
  , "psci-support"
  , "quickcheck"
  , "web-html"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/AffGameSnakeJs/src/**/*.purs" ]
}
