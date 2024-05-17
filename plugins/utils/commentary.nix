{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.commentary;
in
{
  # TODO Add support for additional filetypes. This requires autocommands!

  options = {
    plugins.commentary = {
      enable = mkEnableOption "commentary";

      package = helpers.mkPluginPackageOption "commentary" pkgs.vimPlugins.vim-commentary;
    };
  };

  config = mkIf cfg.enable { extraPlugins = [ cfg.package ]; };
}
