{ pkgs ? import <nixpkgs> {} }:

let
  easy-ps = import (
    pkgs.fetchFromGitHub {
      owner = "justinwoo";
      repo = "easy-purescript-nix";
      # Latest `rev` and `sha256` can be obtained by using
      # ```
      # $ nix-prefetch-git https://github.com/justinwoo/easy-purescript-nix.git
      # ```
      rev = "3d8b602e80c0fa7d97d7f03cb8e2f8b06967d509";
      sha256 = "0kvnsc4j0h8qvv69613781i2qy51rcbmv5ga8j21nsqzy3l8fd9w";
    }
  ) {
    inherit pkgs;
  };

in
pkgs.mkShell {
  buildInputs = [ easy-ps.purs easy-ps.psc-package-simple easy-ps.spago easy-ps.spago2nix ];
}
