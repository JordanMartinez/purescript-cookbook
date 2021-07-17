{ name = "SimpleASTParserLog"
, dependencies =
  [ "console"
  , "control"
  , "effect"
  , "either"
  , "foldable-traversable"
  , "integers"
  , "maybe"
  , "numbers"
  , "prelude"
  , "psci-support"
  , "string-parsers"
  , "strings"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/SimpleASTParserLog/src/**/*.purs" ]
}
