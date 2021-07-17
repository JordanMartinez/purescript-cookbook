{ name = "ShapesHalogenHooks"
, dependencies =
  [ "console"
  , "effect"
  , "halogen"
  , "halogen-hooks"
  , "halogen-svg-elems"
  , "maybe"
  , "prelude"
  , "psci-support"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/ShapesHalogenHooks/src/**/*.purs" ]
}
