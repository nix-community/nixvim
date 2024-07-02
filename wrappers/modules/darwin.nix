{ lib, ... }:
{
  imports = [ ./enable.nix ];

  config = {
    wrapRc = lib.mkForce true;
  };
}
