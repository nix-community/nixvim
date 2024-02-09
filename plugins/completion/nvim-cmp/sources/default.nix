{
  lib,
  config,
  helpers,
  pkgs,
  ...
}:
with lib; let
  cmpLib = import ../cmp-helpers.nix {inherit lib config helpers pkgs;};
  cmpSourcesPluginNames = attrValues cmpLib.pluginAndSourceNames;
  pluginModules = lists.map (name: cmpLib.mkCmpSourcePlugin {inherit name;}) cmpSourcesPluginNames;
in {
  # For extra cmp plugins
  imports =
    [
      ./codeium-nvim.nix
      ./copilot-cmp.nix
      ./cmp-tabby.nix
      ./cmp-tabnine.nix
      ./crates-nvim.nix
    ]
    ++ pluginModules;
}
