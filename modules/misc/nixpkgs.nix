{
  defaultPkgs,
  pkgs,
  lib,
  ...
}:
let
  # TODO: https://github.com/nix-community/nixvim/issues/1784
  finalPackage = defaultPkgs;
in
{
  config = {
    _module.args = {
      # We explicitly set the default override priority, so that we do not need
      # to evaluate finalPkgs in case an override is placed on `_module.args.pkgs`.
      # After all, to determine a definition priority, we need to evaluate `._type`,
      # which is somewhat costly for Nixpkgs. With an explicit priority, we only
      # evaluate the wrapper to find out that the priority is lower, and then we
      # don't need to evaluate `finalPkgs`.
      pkgs = lib.mkOverride lib.modules.defaultOverridePriority finalPackage;
      inherit (pkgs) lib;
    };
  };
}
