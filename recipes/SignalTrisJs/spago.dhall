{ name = "SignalTrisJs"
, dependencies =
  [ "canvas"
  , "colors"
  , "heterogeneous"
  , "quickcheck"
  , "signal"
  , "web-html"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/SignalTrisJs/src/**/*.purs" ]
}
