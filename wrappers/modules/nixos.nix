{ lib, ... }:
{
  options = {
    defaultEditor = lib.mkEnableOption "nixvim as the default editor";
  };

  imports = [ ./enable.nix ];

  config = {
    wrapRc = lib.mkForce true;
    target = lib.mkDefault "sysinit.lua";
  };
}
