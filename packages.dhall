let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.15.3-20220712/packages.dhall
        sha256:ffc496e19c93f211b990f52e63e8c16f31273d4369dbae37c7cf6ea852d4442f

let overrides =
      { react-basic-dom =
        { dependencies =
          [ "effect"
          , "foldable-traversable"
          , "foreign-object"
          , "maybe"
          , "nullable"
          , "prelude"
          , "react-basic"
          , "unsafe-coerce"
          , "web-dom"
          , "web-events"
          , "web-file"
          , "web-html"
          ]
        , repo = "https://github.com/lumihq/purescript-react-basic-dom.git"
        , version = "4633ad95b47a5806ca559dfb3b16b5339564f0ad"
        }
      }

let additions = {=}

in  upstream // overrides // additions
