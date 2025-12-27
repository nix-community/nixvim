{ lib, config, ... }:
let
  inherit (lib)
    types
    ;
in
{
  perSystem = {
    # per-system CI options
    options.ci = {
      buildbot = lib.mkOption {
        type = types.lazyAttrsOf types.raw;
        default = { };
        description = ''
          A set of tests for [buildbot] to run.

          [buildbot]: https://buildbot.nix-community.org
        '';
      };
    };
  };

  flake = {
    # top-level CI option
    #
    # NOTE:
    #   This must be an actual option, NOT a set of options.
    #   Otherwise, flake partitions will not be lazy.
    options.ci = lib.mkOption {
      type = types.lazyAttrsOf (types.lazyAttrsOf types.raw);
      default = { };
      description = ''
        Outputs related to CI.

        Usually defined via the `perSystem.ci` options.
      '';
    };

    # Transpose per-system definitions to the top-level
    config.ci = {
      buildbot = builtins.mapAttrs (_: sysCfg: sysCfg.ci.buildbot) config.allSystems;
    };
  };
}
