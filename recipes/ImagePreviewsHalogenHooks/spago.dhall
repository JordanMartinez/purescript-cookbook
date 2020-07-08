{ name = "ImagePreviewsHalogenHooks"
, dependencies =
  [ "console"
  , "effect"
  , "halogen-css"
  , "halogen-hooks"
  , "halogen-hooks-extra"
  , "psci-support"
  , "random"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/ImagePreviewsHalogenHooks/src/**/*.purs" ]
}
