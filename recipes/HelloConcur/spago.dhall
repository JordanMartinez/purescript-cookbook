{ name = "HelloConcur"
, dependencies =
  [ "console"
  , "effect"
  , "concur-react"
  , "psci-support"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/HelloConcur/src/**/*.purs" ]
}
