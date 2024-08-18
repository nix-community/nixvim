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
    name = "examples";
    cases =
      let
        config = import ../example.nix { inherit pkgs; };
      in
      [
        {
          name = "main";
          case = builtins.removeAttrs config.programs.nixvim [
            # This is not available to standalone modules, only HM & NixOS Modules
            "enable"
            # This is purely an example, it does not reflect a real usage
            "extraConfigLua"
            "extraConfigVim"
          ];
        }
      ];
  };
in
# We attempt to build & execute all configurations
builtins.listToAttrs (
  builtins.map (
    { name, cases }:

    let
      # The test case can either be the actual definition,
      # or a child attr named `module`.
      prepareModule = case: case.module or (lib.removeAttrs case [ "tests" ]);
      dontRunModule = case: case.tests.dontRun or false;
      mkTest =
        { name, case }:
        {
          inherit name;
          path = mkTestDerivationFromNixvimModule {
            inherit name;
            module = prepareModule case;
            dontRun = dontRunModule case;
            pkgs = pkgsUnfree;
          };
        };
    in
    {
      name = "test-${name}";
      value = pkgs.linkFarm "test-${name}" (lib.map mkTest cases);
    }
  ) (testFiles ++ [ exampleFiles ])
)
