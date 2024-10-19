{ lib, ... }:
{
  options = {
    enable = lib.mkEnableOption "nixvim";

    meta.wrapper = {
      name = lib.mkOption {
        type = lib.types.str;
        description = "The human-readable name of this nixvim wrapper. Used in documentation.";
        internal = true;
      };
    };
  };

  imports = [
    ./nixpkgs.nix
  ];
}
