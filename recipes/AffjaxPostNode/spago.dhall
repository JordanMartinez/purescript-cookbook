{ name = "AffjaxPostNode"
, dependencies =
  [ "affjax", "argonaut", "console", "effect", "node-fs-aff", "psci-support" ]
, packages = ../../packages.dhall
, sources = [ "recipes/AffjaxPostNode/src/**/*.purs" ]
}
