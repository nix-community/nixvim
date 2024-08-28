{
  lib ? pkgs.lib,
  helpers,
  pkgs,
  pkgsUnfree,
}:
let
  fetchTests = import ./fetch-tests.nix;
  test-derivation = import ../lib/tests.nix { inherit pkgs lib; };
  inherit (test-derivation) mkTestDerivationFromNixvimModule;

  moduleToTest =
    name: module:
    mkTestDerivationFromNixvimModule {
      inherit name module;
      pkgs = pkgsUnfree;
    };

  # List of files containing configurations
  testFiles = fetchTests {
    inherit lib pkgs helpers;
    root = ./test-sources;
  };

  exampleFiles = {
    name = "examples";
    file = ../example.nix;
    cases =
      let
        config = import ../example.nix { inherit pkgs; };
      in
      {
        main = builtins.removeAttrs config.programs.nixvim [
          # This is not available to standalone modules, only HM & NixOS Modules
          "enable"
          # This is purely an example, it does not reflect a real usage
          "extraConfigLua"
          "extraConfigVim"
        ];
      };
  };
in
# We attempt to build & execute all configurations
lib.pipe (testFiles ++ [ exampleFiles ]) [
  (builtins.map (file: {
    inherit (file) name;
    path = pkgs.linkFarm file.name (builtins.mapAttrs moduleToTest file.cases);
  }))
  (helpers.groupListBySize 10)
  (lib.imap1 (
    i: group: rec {
      name = "test-${toString i}";
      value = pkgs.linkFarm name group;
    }
  ))
  builtins.listToAttrs
]
