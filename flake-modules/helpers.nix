{
  perSystem =
    { pkgs, ... }:
    {
      _module.args.helpers = import ../lib/helpers.nix { inherit pkgs; };
    };
}
