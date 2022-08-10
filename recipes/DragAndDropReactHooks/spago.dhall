{ name = "DragAndDropReactHooks"
, dependencies =
  [ "effect"
  , "exceptions"
  , "foldable-traversable"
  , "maybe"
  , "nullable"
  , "prelude"
  , "react-basic"
  , "react-basic-dom"
  , "react-basic-hooks"
  , "web-dom"
  , "web-file"
  , "web-html"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/DragAndDropReactHooks/src/**/*.purs" ]
}
