{ name = "AffjaxPostNode"
, dependencies =
  [ "aff"
  , "affjax"
  , "argonaut"
  , "console"
  , "effect"
  , "either"
  , "maybe"
  , "node-fs-aff"
  , "prelude"
  , "psci-support"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/AffjaxPostNode/src/**/*.purs" ]
}
