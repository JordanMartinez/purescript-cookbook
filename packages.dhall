let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.13.8-20200716/packages.dhall sha256:c4683b4c4da0fd33e0df86fc24af035c059270dd245f68b79a7937098f6c6542

let overrides = {=}

let additions =
      { canvas-action =
            { dependencies =
                  [ "free"
                  , "exceptions"
                  , "newtype"
                  , "effect"
                  , "maybe"
                  , "web-html"
                  , "foldable-traversable"
                  , "polymorphic-vectors"
                  , "prelude"
                  , "transformers"
                  , "canvas"
                  , "math"
                  , "tuples"
                  , "partial"
                  , "colors"
                  , "lists"
                  ]
            , repo = "https://github.com/3ddyy/purescript-canvas-action.git"
            , version = "v4.0.1"
            }
      , polymorphic-vectors =
            { dependencies = [ "prelude", "canvas", "math" ]
            , repo = "https://github.com/3ddyy/purescript-polymorphic-vectors.git"
            , version = "v1.1.1"
            }
      , game =
            { dependencies =
                    [ "aff"
                  , "canvas-action"
                  , "console"
                  , "control"
                  , "datetime"
                  , "effect"
                  , "filterable"
                  , "foldable-traversable"
                  , "fork"
                  , "free"
                  , "functors"
                  , "identity"
                  , "js-timers"
                  , "monad-loops"
                  , "newtype"
                  , "now"
                  , "parallel"
                  , "partial"
                  , "polymorphic-vectors"
                  , "prelude"
                  , "psci-support"
                  , "record"
                  , "record-extra"
                  , "refs"
                  , "run"
                  , "tailrec"
                  , "typelevel-prelude"
                  , "undefined"
                  , "variant"
                  , "web-html"
                  , "web-uievents"
                  ]
            , repo = "https://github.com/3ddyy/purescript-game.git"
            , version = "c47feafaeded09398e78120017285e9bdd509715"
            }
      }

in  upstream // overrides // additions
