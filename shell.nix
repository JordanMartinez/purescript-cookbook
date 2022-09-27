let
  sources = import ./nix/sources.nix { };
  pkgs = import sources.nixpkgs { };
  easy-ps = import sources.easy-purescript-nix { inherit pkgs; };
in

pkgs.mkShell {
  buildInputs = with easy-ps; [
    purs
    psc-package-simple
    spago
    spago2nix
  ] ++ (with pkgs; [
    nodejs
    niv
  ]);
}
