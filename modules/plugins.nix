{ lib, ... }:
let
  inherit (builtins) readDir;
  inherit (lib.attrsets) foldlAttrs;
  inherit (lib.lists) optional;
  by-name = ../plugins/by-name;
in
{
  imports = [
    ../plugins
  ]
  ++ foldlAttrs (
    prev: name: type:
    prev ++ optional (type == "directory") (by-name + "/${name}")
  ) [ ] (readDir by-name);
}
