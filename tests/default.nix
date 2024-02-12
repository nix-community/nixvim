{
  makeNixvim,
  lib,
  helpers,
  pkgs,
}: let
  fetchTests = import ./fetch-tests.nix;
  test-derivation = import ./test-derivation.nix {inherit pkgs makeNixvim;};
  inherit (test-derivation) mkTestDerivation;

  # List of files containing configurations
  testFiles = fetchTests {
    inherit lib pkgs helpers;
    root = ./test-sources;
  };

  exampleFiles = {
    example = let
      config = import ../example.nix {inherit pkgs;};
    in
      builtins.removeAttrs config.programs.nixvim [
        # This is not available to standalone modules, only HM & NixOS Modules
        "enable"
        # This is purely an example, it does not reflect a real usage
        "extraConfigLua"
        "extraConfigVim"
      ];
  };

  # We attempt to build & execute all configurations
  derivationList =
    pkgs.lib.mapAttrsToList
    (
      name: path: {
        inherit name;
        path = mkTestDerivation name path;
      }
    )
    (testFiles // exampleFiles);
in
  pkgs.linkFarm "nixvim-tests" derivationList
