{ name = "DiceLog"
, dependencies = [ "console", "effect", "prelude", "psci-support", "random" ]
, packages = ../../packages.dhall
, sources = [ "recipes/DiceLog/src/**/*.purs" ]
}
