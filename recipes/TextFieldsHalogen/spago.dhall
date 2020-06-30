{ name = "HelloHalogen"
, dependencies =
  [ "console", "effect", "halogen-hooks", "psci-support", "stringutils" ]
, packages = ../../packages.dhall
, sources = [ "recipes/HelloHalogen/src/**/*.purs" ]
}
