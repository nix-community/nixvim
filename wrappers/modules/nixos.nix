{ lib, ... }:
{
  options = {
    defaultEditor = lib.mkEnableOption "nixvim as the default editor";
  };

  imports = [ ./shared.nix ];
}
