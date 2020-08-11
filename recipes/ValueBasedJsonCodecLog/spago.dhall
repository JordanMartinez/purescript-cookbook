{ name = "ValueBasedJsonCodecLog"
, dependencies = [ "codec", "argonaut-core", "codec-argonaut", "maybe", "either", "console", "effect", "psci-support" ]
, packages = ../../packages.dhall
, sources = [ "recipes/ValueBasedJsonCodecLog/src/**/*.purs" ]
}
