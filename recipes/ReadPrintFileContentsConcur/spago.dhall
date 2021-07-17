{ name = "ReadPrintFileContentsConcur"
, dependencies =
  [ "aff"
  , "concur-core"
  , "concur-react"
  , "console"
  , "dom-filereader"
  , "effect"
  , "maybe"
  , "prelude"
  , "psci-support"
  , "react"
  , "unsafe-coerce"
  , "web-events"
  , "web-file"
  , "web-html"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/ReadPrintFileContentsConcur/src/**/*.purs" ]
}
