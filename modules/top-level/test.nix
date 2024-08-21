{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.test;
in
{
  options.test = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "nixvim-check";
      description = "The test derivation's name.";
    };

    runNvim = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to run `nvim` in the test.";
      default = true;
    };

    # Output
    derivation = lib.mkOption {
      type = lib.types.package;
      description = ''
        A derivation that tests the config by running neovim.
      '';
      readOnly = true;
    };
  };

  config = {
    test.derivation = pkgs.stdenv.mkDerivation {
      inherit (cfg) name;
      dontUnpack = true;

      nativeBuildInputs = [ config.finalPackage ];

      # We need to set HOME because neovim will try to create some files
      #
      # Because neovim does not return an exitcode when quitting we need to check if there are
      # errors on stderr
      buildPhase = lib.optionalString cfg.runNvim ''
        mkdir -p .cache/nvim

        output=$(HOME=$(realpath .) nvim -mn --headless "+q" 2>&1 >/dev/null)
        if [[ -n $output ]]; then
          echo "ERROR: $output"
          exit 1
        fi
      '';

      # If we don't do this nix is not happy
      installPhase = ''
        touch $out
      '';
    };
  };
}
