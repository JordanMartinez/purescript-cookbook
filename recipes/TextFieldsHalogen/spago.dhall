{ name = "HelloHalogen"
, dependencies =
  [ "console", "effect", "halogen-hooks", "psci-support" ]
, packages = ../../packages.dhall
, sources = [ "recipes/HelloHalogen/src/**/*.purs" ]
}
