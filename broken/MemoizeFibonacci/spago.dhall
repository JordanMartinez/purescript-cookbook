{ name = "MemoizeFibonacci"
, dependencies =
  [ "console", "debug", "effect", "interpolate", "memoize", "psci-support" ]
, packages = ../../packages.dhall
, sources = [ "recipes/MemoizeFibonacci/src/**/*.purs" ]
}
