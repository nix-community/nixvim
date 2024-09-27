{ lib, ... }:
{
  options = {
    defaultEditor = lib.mkEnableOption "nixvim as the default editor";

    vimdiffAlias = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Alias `vimdiff` to `nvim -d`.
      '';
    };
  };

  imports = [ ./enable.nix ];

  config = {
    wrapRc = lib.mkOptionDefault false;
    impureRtp = lib.mkOptionDefault true;
  };
}
