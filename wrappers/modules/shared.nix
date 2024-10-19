{ lib, ... }:
{
  options = {
    enable = lib.mkEnableOption "nixvim";

    nixpkgs.useGlobalPackages = lib.mkOption {
      type = lib.types.bool;
      default = true; # TODO: Added 2024-12-23; switch to false one release after adding a deprecation warning
      defaultText = lib.literalMD ''`true`, but will change to `false` in a future version.'';
      description = ''
        Whether Nixvim should use the host configuration's `pkgs` instance.
        When false, `pkgs` will be constructed from `nixpkgs.source`.

        > [!TIP]
        > The host configuration is usually home-manager, nixos, or nix-darwin.
      '';
    };

    meta.wrapper = {
      name = lib.mkOption {
        type = lib.types.str;
        description = "The human-readable name of this nixvim wrapper. Used in documentation.";
        internal = true;
      };
    };
  };
}
