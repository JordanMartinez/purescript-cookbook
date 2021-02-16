{ name = "ParallelAppMExampleLog"
, dependencies =
  [ "console"
  , "control"
  , "effect"
  , "either"
  , "foldable-traversable"
  , "functions"
  , "functors"
  , "maybe"
  , "newtype"
  , "prelude"
  , "psci-support"
  , "refs"
  , "transformers"
  , "aff"
  , "random"
  , "unfoldable"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/ParallelAppMExampleLog/src/**/*.purs" ]
}
{-
sources does not work with paths relative to this config
  sources = [ "src/**/*.purs" ]
Paths must be relative to where this command is run
-}
