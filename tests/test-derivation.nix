{
  pkgs,
  lib ? pkgs.lib,
  ...
}:
let
  # Create a nix derivation from a nixvim executable.
  # The build phase simply consists in running the provided nvim binary.
  mkTestDerivationFromNvim =
    {
      name,
      nvim ? null,
      tests ? [ ],
      dontRun ? false,
      ...
    }:
    # At least one of these should be undefined
    assert lib.assertMsg (tests == [ ] || nvim == null) "Both nvim & tests can't be supplied";
    let
      nvimAsList = lib.optional (nvim != null) {
        derivation = nvim;
        inherit name dontRun;
      };

      testList = tests ++ nvimAsList;
    in
    pkgs.stdenv.mkDerivation {
      inherit name;

      nativeBuildInputs = [ pkgs.docker-client ];

      dontUnpack = true;
      # We need to set HOME because neovim will try to create some files
      #
      # Because neovim does not return an exitcode when quitting we need to check if there are
      # errors on stderr
      buildPhase = lib.optionalString (!dontRun) (
        ''
          mkdir -p .cache/nvim
        ''
        + lib.concatStringsSep "\n" (
          builtins.map (
            {
              derivation,
              name,
              dontRun ? false,
            }:
            lib.optionalString (!dontRun) ''
              echo "Running test for ${name}"

              output=$(HOME=$(realpath .) ${lib.getExe derivation} -mn --headless "+q" 2>&1 >/dev/null)
              if [[ -n $output ]]; then
                echo "ERROR: $output"
                exit 1
              fi
            ''
          ) testList
        )
      );

      # If we don't do this nix is not happy
      installPhase = ''
        mkdir $out
      '';
    };

  # Create a nix derivation from a nixvim configuration.
  # The build phase simply consists in running neovim with the given configuration.
  mkTestDerivationFromNixvimModule =
    {
      name ? "nixvim-check",
      pkgs ? pkgs,
      module ? null,
      tests ? [ ],
      extraSpecialArgs ? { },
      dontRun ? false,
    }:
    # At least one of these should be undefined
    assert lib.assertMsg (tests == [ ] || module == null) "Both module & tests can't be supplied";
    let
      helpers = import ../lib/helpers.nix {
        inherit pkgs lib;
        _nixvimTests = true;
      };
      moduleAsList = lib.optional (module != null) { inherit module name; };
      moduleList = tests ++ moduleAsList;
      testDerivations = builtins.map (
        {
          module,
          name,
          dontRun ? false,
        }@args:
        let
          result = lib.evalModules {
            modules = [
              module
              ./_module.nix
              ../modules/top-level
            ] ++ lib.optional (args ? dontRun) { tests.dontRun = lib.mkDefault dontRun; };
            specialArgs = helpers.modules.specialArgsWith extraSpecialArgs;
          };

          # TODO: allow "expecting" specific errors
          inherit (result.config) warnings;
          assertions = lib.pipe result.config.assertions [
            (lib.filter (x: !x.assertion))
            (lib.map (x: x.message))
          ];

          errors = pkgs.runCommand name { inherit name assertions warnings; } ''
            echo "Issues found evaluating $name":
            if [ -n "$assertions" ]; then
              echo "Unexpected assertions:"
              for it in "$assertions"; do
                echo "- $it"
              done
              echo
            fi
            if [ -n "$warnings" ]; then
              echo "Unexpected warnings:"
              for it in "$warnings"; do
                echo "- $it"
              done
              echo
            fi
            exit 1
          '';

          inherit (result.config) finalPackage;
        in
        {
          inherit name;
          inherit (result.config.tests) dontRun;
          derivation = if assertions == [ ] && warnings == [ ] then finalPackage else errors;
        }
      ) moduleList;
    in
    mkTestDerivationFromNvim {
      inherit name dontRun;
      tests = testDerivations;
    };
in
{
  inherit mkTestDerivationFromNvim mkTestDerivationFromNixvimModule;
}
