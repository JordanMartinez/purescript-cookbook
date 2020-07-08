{ name = "DragAndDropHalogenHooks"
, dependencies =
  [ "console"
  , "effect"
  , "halogen-css"
  , "halogen-hooks"
  , "halogen-hooks-extra"
  , "interpolate"
  , "psci-support"
  , "random"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/DragAndDropHalogenHooks/src/**/*.purs" ]
}
