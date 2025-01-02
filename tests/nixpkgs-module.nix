{
  lib,
  linkFarmFromDrvs,
  nixvimConfiguration,
  runCommandNoCCLocal,
  self,
  system,
}:
let
  # Writes a runCommand style derivation based on a nixvim module's output
  testModule =
    {
      name,
      module,
      drvArgs,
      script,
    }:
    let
      configuration = nixvimConfiguration.extendModules {
        modules = lib.toList module;
      };
      finalDrvArgs = {
        __structuredAttrs = true;
      } // drvArgs (configuration._module.args // configuration);
    in
    runCommandNoCCLocal name finalDrvArgs script;

  # Writes a test derivation that checks specific variables have the expected values
  testExpectations =
    {
      name,
      module,
      drvArgs,
      expectations,
    }:
    let
      checks = lib.concatLines (
        lib.mapAttrsToList (name: expected: ''
          ${lib.toShellVar "_expected" expected}
          if [ "${"$" + name}" != "$_expected" ]; then
            error+='- Expected ${name} to be "'"$_expected"'" but found "'"${"$" + name}"'"'
          fi
        '') expectations
      );
    in
    testModule {
      inherit name module drvArgs;
      script = ''
        error=""
        ${checks}
        if [ -n "$error" ]; then
          echo "${name} failed:"
          echo "$error"
          exit 1
        fi
        touch $out
      '';
    };

  # Further simplifies `testExpectations` when all the expectations relate to attrs in `pkgs`
  testPkgsExpectations =
    {
      name,
      module,
      expectations,
    }:
    testExpectations {
      inherit name module expectations;
      drvArgs = { pkgs, ... }: lib.mapAttrs (name: _: pkgs.${name} or null) expectations;
    };
in
linkFarmFromDrvs "nixpkgs-module-tests" [

  (testPkgsExpectations {
    name = "overlays-are-applied";
    module = {
      nixpkgs.overlays = [
        (final: prev: {
          foobar = "foobar";
        })
      ];
    };
    expectations = {
      foobar = "foobar";
    };
  })

  (testPkgsExpectations {
    name = "overlays-can-be-stacked";
    module = {
      nixpkgs.pkgs = import self.inputs.nixpkgs {
        inherit system;
        overlays = [
          (final: prev: {
            foobar = "foobar";
            conflict = "a";
          })
        ];
      };
      nixpkgs.overlays = [
        (final: prev: {
          hello = "world";
          conflict = "b";
        })
      ];

    };
    expectations = {
      foobar = "foobar";
      hello = "world";
      conflict = "b";
    };
  })

]
