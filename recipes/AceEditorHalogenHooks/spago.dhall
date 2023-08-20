{ name = "AceEditorHalogenHooks"
, dependencies =
  [ "ace"
  , "aff"
  , "effect"
  , "foldable-traversable"
  , "halogen"
  , "halogen-hooks"
  , "halogen-subscriptions"
  , "maybe"
  , "prelude"
  , "tuples"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/AceEditorHalogenHooks/src/**/*.purs" ]
}
