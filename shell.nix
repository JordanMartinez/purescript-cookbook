{ pkgs ? import <nixpkgs> {} }:

let
  easy-ps = import (
    pkgs.fetchFromGitHub {
      owner = "justinwoo";
      repo = "easy-purescript-nix";
      rev = "01ae1bc844a4eed1af7dfbbb202fdd297e3441b9";
      sha256 = "0jx4xb202j43c504gzh27rp9f2571ywdw39dqp6qs76294zwlxkh";
    }
  ) {
    inherit pkgs;
  };

in
pkgs.mkShell {
  buildInputs = [ easy-ps.purs easy-ps.psc-package-simple easy-ps.spago easy-ps.spago2nix ];
}
