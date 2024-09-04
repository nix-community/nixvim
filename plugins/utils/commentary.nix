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

      package = lib.mkPackageOption pkgs "commentary" {
        default = [
          "vimPlugins"
          "vim-commentary"
        ];
      };
    };
  };

  config = mkIf cfg.enable { extraPlugins = [ cfg.package ]; };
}
