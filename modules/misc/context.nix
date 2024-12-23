{ lib, ... }:
let
  isFlake = x: x._type or null == "flake";
  flakeType = lib.types.addCheck lib.types.path isFlake // {
    name = "flake";
    description = "flake";
  };
in
{
  options = {
    flake = lib.mkOption {
      type = flakeType;
      description = ''
        Nixvim's flake.
      '';
      internal = true;
    };
    isTopLevel = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether modules are being evaluated at the "top-level".
        Should be false when evaluating nested submodules.
      '';
      internal = true;
      visible = false;
    };
    isDocs = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether modules are being evaluated to build documentation.
      '';
      internal = true;
      visible = false;
    };
  };
}
