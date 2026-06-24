{ lib, ... }:
let
  categoryType = lib.types.submoduleWith {
    modules = [ ./category.nix ];
  };
in
{
  freeformType = lib.types.attrsOf categoryType;
  imports = [
    ./menu.nix
  ];
}
