{ name = "FileUploadHalogenHooks"
, dependencies =
  [ "console"
  , "effect"
  , "halogen-hooks"
  , "psci-support"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/FileUploadHalogenHooks/src/**/*.purs" ]
}
