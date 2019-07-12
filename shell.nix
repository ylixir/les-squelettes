{ pkgs ? import <nixpkgs> {} }:
with pkgs;
stdenv.mkDerivation {
  name = "#project#";
  buildInputs = import ./default.nix;
}
