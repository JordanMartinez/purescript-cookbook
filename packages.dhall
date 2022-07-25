let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.15.4-20220723/packages.dhall
        sha256:efb50561d50d0bebe01f8e5ab21cda51662cca0f5548392bafc3216953a0ed88

let overrides = {=}

let additions = {=}

in  upstream // overrides // additions
