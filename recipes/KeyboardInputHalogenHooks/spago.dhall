{ name = "KeyboardInputHalogenHooks"
, dependencies =
  [ "aff"
  , "effect"
  , "halogen"
  , "halogen-hooks"
  , "maybe"
  , "prelude"
  , "strings"
  , "tuples"
  , "web-events"
  , "web-html"
  , "web-uievents"
  ]
, packages = ../../packages.dhall
, sources = [ "recipes/KeyboardInputHalogenHooks/src/**/*.purs" ]
}
