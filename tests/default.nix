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
    in
    {
      inherit name;
      value = mkTestDerivationFromNixvimModule {
        inherit name;
        tests = builtins.map (
          { name, case }:
          {
            inherit name;
            module = prepareModule case;
            dontRun = dontRunModule case;
          }
        ) cases;
        # Use the global dontRun only if we don't have a list of modules
        dontRun = dontRunModule cases;
        pkgs = pkgsUnfree;
      };
    }
  ) (testFiles ++ [ exampleFiles ])
)
