let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.13.8-20200716/packages.dhall sha256:c4683b4c4da0fd33e0df86fc24af035c059270dd245f68b79a7937098f6c6542

let overrides = {=}

let additions =
  { payload =
      { dependencies =
            [ "aff"
            , "affjax"
            , "console"
            , "debug"
            , "effect"
            , "foreign-generic"
            , "node-fs"
            , "node-fs-aff"
            , "node-http"
            , "prelude"
            , "psci-support"
            , "record"
            , "simple-json"
            , "stringutils"
            , "test-unit"
            , "typelevel-prelude"
            ]
      , repo =
          "https://github.com/hoodunit/purescript-payload"
      , version =
          "v0.3.0"
      }
  }

in  upstream // overrides // additions
