{
  lib,
  pkgs,
  ...
} @ attrs:
with lib; let
  cmpLib = import ../cmp-helpers.nix attrs;
  cmpSourcesPluginNames = lib.attrValues cmpLib.pluginAndSourceNames;
  pluginModules = lists.map (name: cmpLib.mkCmpSourcePlugin {inherit name;}) cmpSourcesPluginNames;
in {
  # For extra cmp plugins
  imports =
    [
      ./cmp-tabnine.nix
    ]
    ++ pluginModules;
}
