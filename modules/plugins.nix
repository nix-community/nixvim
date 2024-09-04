{ lib, ... }:
let
  inherit (builtins) readDir pathExists;
  inherit (lib.attrsets) foldlAttrs;
  inherit (lib.lists) optional optionals;
  by-name = ../plugins/by-name;
in
{
  imports =
    [ ../plugins ]
    ++ optionals (pathExists by-name) (
      foldlAttrs (
        prev: name: type:
        prev ++ optional (type == "directory") (by-name + "/${name}")
      ) [ ] (readDir by-name)
    );
}
