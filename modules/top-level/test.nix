{
  pkgs,
  config,
  options,
  lib,
  ...
}:
let
  cfg = config.test;

  inherit (config) warnings;
  assertions = builtins.concatMap (x: lib.optional (!x.assertion) x.message) config.assertions;
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

    checkWarnings = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to check `config.warnings` in the test.";
      default = true;
    };

    checkAssertions = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to check `config.assertions` in the test.";
      default = true;
    };
  };

  options.build = {
    test = lib.mkOption {
      type = lib.types.package;
      description = ''
        A derivation that tests the config by running neovim.
      '';
      readOnly = true;
    };
  };

  config =
    let
      showErr =
        name: lines:
        lib.optionalString (lines != [ ]) ''
          Unexpected ${name}:
          ${lib.concatStringsSep "\n" (lib.map (v: "- ${v}") lines)}
        '';

      toCheck =
        lib.optionalAttrs cfg.checkWarnings { inherit warnings; }
        // lib.optionalAttrs cfg.checkAssertions { inherit assertions; };

      errors = lib.foldlAttrs (
        err: name: lines:
        err + showErr name lines
      ) "" toCheck;
    in
    {
      build.test =
        pkgs.runCommandNoCCLocal cfg.name
          {
            nativeBuildInputs = [ config.build.packageUnchecked ];

            # Allow inspecting the test's module a little from the repl
            # e.g.
            # :lf .
            # :p checks.x86_64-linux.test-1.passthru.entries.modules-autocmd.passthru.entries.example.passthru.config.extraConfigLua
            #
            # Yes, three levels of passthru is cursed.
            passthru = {
              inherit config options;
            };
          }
          (
            # First check warnings/assertions, then run nvim
            lib.optionalString (errors != "") ''
              echo -n ${lib.escapeShellArg errors}
              exit 1
            ''
            # We need to set HOME because neovim will try to create some files
            #
            # Because neovim does not return an exitcode when quitting we need to check if there are
            # errors on stderr
            + lib.optionalString cfg.runNvim ''
              mkdir -p .cache/nvim

              output=$(HOME=$(realpath .) nvim -mn --headless "+q" 2>&1 >/dev/null)
              if [[ -n $output ]]; then
                echo "ERROR: $output"
                exit 1
              fi
            ''
            + ''
              touch $out
            ''
          );
    };
}
