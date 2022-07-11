{ name = "FileUploadReactHooks"
, dependencies =
  [ "console"
  , "effect"
  , "exceptions"
  , "foldable-traversable"
  , "maybe"
  , "prelude"
  , "react-basic"
  , "react-basic-dom"
  , "react-basic-hooks"
  , "web-file"
  , "web-html"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/FileUploadReactHooks/src/**/*.purs" ]
}
