{
  makeNixvimWithModule,
  lib ? pkgs.lib,
  helpers,
  pkgs,
  pkgsUnfree,
}:
let
  fetchTests = import ./fetch-tests.nix;
  test-derivation = import ./test-derivation.nix { inherit pkgs makeNixvimWithModule lib; };
  inherit (test-derivation) mkTestDerivationFromNixvimModule;

  # List of files containing configurations
  testFiles = fetchTests {
    inherit lib pkgs helpers;
    root = ./test-sources;
  };

  exampleFiles = {
    example =
      let
        config = import ../example.nix { inherit pkgs; };
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
  derivationList = pkgs.lib.mapAttrsToList (name: def: {
    inherit name;
    path = mkTestDerivationFromNixvimModule {
      inherit name;
      # The module can either be the actual definition,
      # or a child attr named `module`.
      module = def.module or (lib.removeAttrs def [ "tests" ]);
      dontRun = def.tests.dontRun or false;
      pkgs = pkgsUnfree;
    };
  }) (testFiles // exampleFiles);
in
pkgs.linkFarm "nixvim-tests" derivationList
