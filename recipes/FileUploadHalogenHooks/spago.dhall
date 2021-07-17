{ name = "FileUploadHalogenHooks"
, dependencies =
  [ "console"
  , "dom-indexed"
  , "effect"
  , "halogen"
  , "halogen-hooks"
  , "maybe"
  , "prelude"
  , "psci-support"
  , "tuples"
  , "web-file"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/FileUploadHalogenHooks/src/**/*.purs" ]
}
