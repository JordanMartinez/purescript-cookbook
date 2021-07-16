let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.14.3-20210716/packages.dhall sha256:1f9af624ddfd5352455b7ac6df714f950d499e7e3c6504f62ff467eebd11042c

let overrides = {=}

let additions = {=}

in  upstream // overrides // additions
