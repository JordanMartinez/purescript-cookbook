{ name = "FileUploadHalogenHooks"
, dependencies =
  [ "dom-indexed"
  , "effect"
  , "halogen"
  , "halogen-hooks"
  , "maybe"
  , "prelude"
  , "tuples"
  , "web-file"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/FileUploadHalogenHooks/src/**/*.purs" ]
}
