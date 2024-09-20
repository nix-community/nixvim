{
  config,
  lib,
  withSystem,
  ...
}:
{
  _module.args.helpers = import ../lib { inherit lib; };

  # TODO: output lib without pkgs at the top-level
  flake.lib = lib.genAttrs config.systems (
    lib.flip withSystem (
      { pkgs, ... }:
      {
        # NOTE: this is the publicly documented flake output we've had for a while
        check = import ../lib/tests.nix { inherit lib pkgs; };
        # NOTE: user-facing so we must include the legacy `pkgs` argument
        helpers = import ../lib { inherit lib pkgs; };
      }
    )
  );
}
