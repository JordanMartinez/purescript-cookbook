{ name = "DragAndDropReactHooks"
, dependencies =
  [ "console"
  , "effect"
  , "exceptions"
  , "foldable-traversable"
  , "maybe"
  , "nullable"
  , "prelude"
  , "react-basic"
  , "react-basic-dom"
  , "react-basic-hooks"
  , "web-file"
  , "web-html"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/DragAndDropReactHooks/src/**/*.purs" ]
}
