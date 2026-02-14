{ lib, ... }:
{
  options = {
    defaultEditor = lib.mkEnableOption "nixvim as the default editor";
  };

  imports = [ ./shared.nix ];

  config = {
    wrapRc = lib.mkOptionDefault false;
    impureRtp = lib.mkOptionDefault true;
    meta.wrapper.name = "home-manager";
  };
}
