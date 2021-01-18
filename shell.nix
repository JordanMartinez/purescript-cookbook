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
      rev = "c8c32741bc09e2ac0a94d5140cf51fa5de809e24";
      sha256 = "0rn938nbxqsd7lp7l8z1y7bhzaq29vbziq6hq9llb3yh9xs10lmf";
    }
  ) {
    inherit pkgs;
  };

in
pkgs.mkShell {
  buildInputs = [ easy-ps.purs easy-ps.psc-package-simple easy-ps.spago easy-ps.spago2nix ];
}
