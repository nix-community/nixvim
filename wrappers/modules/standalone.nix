{ lib, ... }:
{
  config = {
    wrapRc = lib.mkForce true;
  };
}
