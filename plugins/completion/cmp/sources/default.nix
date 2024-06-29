{
  lib,
  config,
  helpers,
  pkgs,
  ...
}:
with lib;
let
  cmpLib = import ../cmp-helpers.nix {
    inherit
      lib
      config
      helpers
      pkgs
      ;
  };

  cmpSourcesPluginNames = import ../sources.nix;
  pluginModules = mapAttrsToList (
    sourceName: name: cmpLib.mkCmpSourcePlugin { inherit sourceName name; }
  ) cmpSourcesPluginNames;
in
{
  # For extra cmp plugins
  imports = [
    ./codeium-nvim.nix
    ./copilot-cmp.nix
    ./cmp-ai.nix
    ./cmp-fish.nix
    ./cmp-git.nix
    ./cmp-tabby.nix
    ./cmp-tabnine.nix
    ./crates-nvim.nix
  ] ++ pluginModules;
}
