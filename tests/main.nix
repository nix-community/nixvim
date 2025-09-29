# Collects the various test modules in tests/test-sources/ and groups them into a number of test derivations
{
  callTest,
  lib ? pkgs.lib,
  linkFarm,
  pkgs,
  pkgsForTest,
}:
let
  fetchTests = callTest ./fetch-tests.nix { };

  moduleToTest =
    file: name: module:
    let
      configuration = lib.nixvim.modules.evalNixvim {
        modules = [
          {
            test.name = lib.mkDefault name;
            _module.args.pkgs = lib.mkForce pkgsForTest;
          }
          {
            _file = file;
            imports = lib.toList module;
          }
        ];
      };
    in
    configuration.config.build.test.overrideAttrs (old: {
      passthru =
        old.passthru or { }
        // builtins.removeAttrs configuration [
          "_type"
          "type"
        ]
        // {
          inherit file module;
          optionType = configuration.type;
        };
    });

  # List of files containing configurations
  testFiles = fetchTests ./test-sources;

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
{
  tests = map (
    {
      name,
      file,
      cases,
    }:
    {
      inherit name;
      path = linkFarm name (builtins.mapAttrs (moduleToTest file) cases);
    }
  ) (testFiles ++ [ exampleFiles ]);
}
