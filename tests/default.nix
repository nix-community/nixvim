{
  lib ? pkgs.lib,
  helpers,
  pkgs,
  pkgsUnfree,
}:
let
  fetchTests = import ./fetch-tests.nix;

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
      prepareModule =
        case: if lib.isFunction case then case else case.module or (lib.removeAttrs case [ "tests" ]);
      dontRunModule =
        case:
        let
          dontRun = case.tests.dontRun or false;
        in
        lib.optionalAttrs dontRun { test.runNvim = false; };

      # Evaluates a test-case definition and returns the `test.test` option value
      getTest =
        { name, case }:
        let
          result = helpers.modules.evalNixvim {
            modules = [
              { test.name = name; }
              (dontRunModule case)
              (prepareModule case)
            ];
            extraSpecialArgs = {
              # TODO: enable unfree via nixpkgs.config module (#1784)
              defaultPkgs = pkgsUnfree;
            };
            # Don't check assertions/warnings while evaluating nixvim config
            # We'll let the test derivation handle that
            check = false;
          };
        in
        {
          inherit name;
          path = result.config.test.test;
        };
    in
    {
      name = "test-${name}";
      value = pkgs.linkFarm "test-${name}" (lib.map getTest cases);
    }
  ) (testFiles ++ [ exampleFiles ])
)
