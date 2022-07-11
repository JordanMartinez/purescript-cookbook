{ name = "AffjaxPostNode"
, dependencies =
  [ "aff"
  , "affjax"
  , "affjax-node"
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
