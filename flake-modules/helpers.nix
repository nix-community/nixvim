{ getHelpers, ... }:
{
  _module.args.getHelpers =
    pkgs: _nixvimTests:
    import ../lib/helpers.nix {
      inherit pkgs _nixvimTests;
      inherit (pkgs) lib;
    };

  perSystem =
    { pkgs, config, ... }:
    {
      _module.args.helpers = getHelpers pkgs false;
    };
}
