{
  makeNixvim,
  lib,
  pkgs,
}: let
  fetchTests = import ./fetch-tests.nix;
  mkTestDerivation = import ./test-derivation.nix {inherit pkgs makeNixvim;};

  # List of files containing configurations
  testFiles = fetchTests {
    inherit lib pkgs;
    root = ./test-sources;
  };
in
  # We attempt to build & execute all configurations
  builtins.mapAttrs mkTestDerivation testFiles
