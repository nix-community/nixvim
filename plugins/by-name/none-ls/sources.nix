{ config, lib, ... }:
let
  noneLsBuiltins = lib.importJSON ../../../generated/none-ls-sources.json;
  mkSourcePlugin = import ./_mk-source-plugin.nix;
in
{
  imports = [
    ./prettier.nix
    ./prettierd.nix
  ]
  ++ (lib.flatten (
    lib.mapAttrsToList (category: (lib.map (mkSourcePlugin category))) noneLsBuiltins
  ));

  config =
    let
      cfg = config.plugins.none-ls;
      gitsignsEnabled = cfg.sources.code_actions.gitsigns.enable;
    in
    lib.mkIf cfg.enable {
      # Enable gitsigns if the gitsigns source is enabled
      plugins.gitsigns.enable = lib.mkIf gitsignsEnabled true;
    };
}
