{getHelpers, ...}: {
  _module.args.getHelpers = pkgs:
    import ../lib/helpers.nix {
      inherit pkgs;
      inherit (pkgs) lib;
    };

  perSystem = {
    pkgs,
    config,
    ...
  }: {
    _module.args.helpers = getHelpers pkgs;
  };
}
