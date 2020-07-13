let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.13.8-20200708/packages.dhall sha256:df5b0f1ae92d4401404344f4fb2a7a3089612c9f30066dcddf9eaea4fe780e29

let overrides = {=}

let additions = {=}

in  upstream // overrides // additions
