{
  makeNixvim,
  makeNixvimWithModule,
  lib,
  helpers,
  pkgs,
}:
let
  fetchTests = import ./fetch-tests.nix;
<<<<<<< HEAD
  test-derivation = import ./test-derivation.nix { inherit pkgs makeNixvim makeNixvimWithModule; };
  inherit (test-derivation) mkTestDerivation;
=======
  test-derivation = import ./test-derivation.nix { inherit pkgs makeNixvimWithModule lib; };
  inherit (test-derivation) mkTestDerivationFromNixvimModule;
>>>>>>> 71126bfe (tests: Allow to test multiple derivations in a single test derivation)

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

  # We attempt to build & execute all configurations
<<<<<<< HEAD
  derivationList = pkgs.lib.mapAttrsToList (name: path: {
    inherit name;
    path = mkTestDerivation name path;
  }) (testFiles // exampleFiles);
=======
  derivationList = builtins.map (
    { name, cases }:
    let
      # The test case can either be the actual definition,
      # or a child attr named `module`.
      prepareModule = case: case.module or (lib.removeAttrs case [ "tests" ]);
      dontRunModule = case: case.tests.dontRun or false;
    in
    {
      inherit name;
      path = mkTestDerivationFromNixvimModule {
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
  ) (testFiles ++ [ exampleFiles ]);
>>>>>>> 50d86527 (tests: Reduce the number of calls to mkTestDerivationFromNixvimModule)
in
pkgs.linkFarm "nixvim-tests" derivationList
