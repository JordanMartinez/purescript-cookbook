{ name = "GroceriesReact"
, dependencies =
  [ "console"
  , "effect"
  , "psci-support"
  , "react-basic-hooks"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/GroceriesReact/src/**/*.purs" ]
}
