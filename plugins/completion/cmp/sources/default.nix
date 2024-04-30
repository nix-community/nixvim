{
  lib,
  config,
  helpers,
  pkgs,
  ...
}:
with lib; let
  cmpLib = import ../cmp-helpers.nix {inherit lib config helpers pkgs;};
  cmpSourcesPluginNames = attrValues (import ../sources.nix);
  pluginModules =
    map
    (
      name:
        cmpLib.mkCmpSourcePlugin {inherit name;}
    )
    cmpSourcesPluginNames;
in {
  # For extra cmp plugins
  imports =
    [
      ./codeium-nvim.nix
      ./copilot-cmp.nix
      ./cmp-fish.nix
      ./cmp-tabby.nix
      ./cmp-tabnine.nix
      ./crates-nvim.nix
    ]
    ++ pluginModules;
}
