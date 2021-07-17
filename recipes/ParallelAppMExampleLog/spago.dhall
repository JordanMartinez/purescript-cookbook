{ name = "ParallelAppMExampleLog"
, dependencies =
  [ "aff"
  , "console"
  , "effect"
  , "foldable-traversable"
  , "integers"
  , "parallel"
  , "prelude"
  , "psci-support"
  , "random"
  , "transformers"
  , "type-equality"
  , "unfoldable"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/ParallelAppMExampleLog/src/**/*.purs" ]
}
