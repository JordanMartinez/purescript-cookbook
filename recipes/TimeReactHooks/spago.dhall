{ name = "TimeReactHooks"
, dependencies =
  [ "arrays"
  , "effect"
  , "exceptions"
  , "integers"
  , "js-date"
  , "js-timers"
  , "maybe"
  , "newtype"
  , "prelude"
  , "react-basic-dom"
  , "react-basic-hooks"
  , "web-html"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/TimeReactHooks/src/**/*.purs" ]
}
