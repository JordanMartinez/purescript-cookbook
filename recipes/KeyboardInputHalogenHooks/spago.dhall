{ name = "KeyboardInputHalogenHooks"
, dependencies =
  [ "console"
  , "effect"
  , "halogen-hooks"
  , "psci-support"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/KeyboardInputHalogenHooks/src/**/*.purs" ]
}
