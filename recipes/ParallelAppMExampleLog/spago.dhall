{ name = "ParallelAppMExampleLog"
, dependencies =
  [ "console"
  , "aff"
  , "effect"
  , "foldable-traversable"
  , "integers"
  , "parallel"
  , "prelude"
  , "random"
  , "transformers"
  , "type-equality"
  , "unfoldable"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/ParallelAppMExampleLog/src/**/*.purs" ]
}
