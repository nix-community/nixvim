{ lib, config, ... }:
let
  inherit (lib)
    mapAttrs
    types
    ;

  buildbotOpt = lib.mkOption {
    type = types.lazyAttrsOf types.package;
    default = { };
    description = ''
      A set of tests for [buildbot] to run.

      [buildbot]: https://buildbot.nix-community.org
    '';
  };
in
{
  perSystem = {
    # Declare per-system CI options
    options.ci = {
      buildbot = buildbotOpt;
    };
  };

  flake = {
    # Declare top-level CI options
    options.ci = {
      buildbot = lib.mkOption {
        type = types.lazyAttrsOf buildbotOpt.type;
        default = { };
        description = ''
          See `perSystem.ci.buildbot` for description and examples.
        '';
      };
    };

    # Transpose per-system CI outputs to the top-level
    config.ci = {
      buildbot = mapAttrs (_: sysCfg: sysCfg.ci.buildbot) config.allSystems;
    };
  };
}
