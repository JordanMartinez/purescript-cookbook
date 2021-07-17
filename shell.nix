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
      rev = "bbef4245cd6810ea84e97a47c801947bfec9fadc";
      sha256 = "00764zbwhbn61jwb5px2syzi2f9djyl8fmbd2p8wma985af54iwx";
    }
  ) {
    inherit pkgs;
  };

in
pkgs.mkShell {
  buildInputs = [ easy-ps.purs easy-ps.psc-package-simple easy-ps.spago easy-ps.spago2nix ];
}
