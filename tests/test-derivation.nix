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
      nvim,
      # TODO: Deprecated 2024-08-20, remove after 24.11
      dontRun ? false,
      ...
    }@args:
    let
      cfg = nvim.config.test;
      runNvim =
        lib.warnIf (args ? dontRun)
          "mkTestDerivationFromNvim: the `dontRun` argument is deprecated. You should use the `test.runNvim` module option instead."
          (cfg.runNvim && !dontRun);
    in
    pkgs.stdenv.mkDerivation {
      inherit name;

      nativeBuildInputs = [
        nvim
        pkgs.docker-client
      ];

      dontUnpack = true;
      # We need to set HOME because neovim will try to create some files
      #
      # Because neovim does not return an exitcode when quitting we need to check if there are
      # errors on stderr
      buildPhase = lib.optionalString runNvim ''
        mkdir -p .cache/nvim

        output=$(HOME=$(realpath .) nvim -mn --headless "+q" 2>&1 >/dev/null)
        if [[ -n $output ]]; then
            echo "ERROR: $output"
          exit 1
        fi
      '';

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
      module,
      extraSpecialArgs ? { },
      # TODO: Deprecated 2024-08-20, remove after 24.11
      dontRun ? false,
    }@args:
    let
      helpers = import ../lib/helpers.nix {
        inherit pkgs lib;
        _nixvimTests = true;
      };
      result = lib.evalModules {
        modules = [
          module
          ../modules/top-level
          (lib.optionalAttrs (args ? dontRun) (
            lib.warn
              "mkTestDerivationFromNixvimModule: the `dontRun` argument is deprecated. You should use the `test.runNvim` module option instead."
              { config.test.runNvim = !dontRun; }
          ))
        ];
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
    # FIXME: 
    if assertions == [ ] && warnings == [ ] then finalPackage else errors;
in
{
  inherit mkTestDerivationFromNvim mkTestDerivationFromNixvimModule;
}
