{ name = "ReadPrintFileContentsConcur"
, dependencies =
  [ "concur-react", "console", "dom-filereader", "effect", "psci-support" ]
, packages = ../../packages.dhall
, sources = [ "recipes/ReadPrintFileContentsConcur/src/**/*.purs" ]
}
