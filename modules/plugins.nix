{ lib, ... }:
let
  inherit (builtins) readDir;
  inherit (lib.attrsets) foldlAttrs;
  inherit (lib.lists) optional concatMap;

  mkByName =
    dir:
    foldlAttrs (
      prev: name: type:
      prev ++ optional (type == "directory") (dir + "/${name}")
    ) [ ] (readDir dir);
in
{
  imports = [
    ../plugins
  ]
  ++ concatMap mkByName [
    ../colorschemes
    ../plugins/by-name
  ];
}
