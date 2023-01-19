{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.plugins.commentary;
in
{
  # TODO Add support for aditional filetypes. This requires autocommands!

  options = {
    plugins.commentary = {
      enable = mkEnableOption "Enable commentary";

      package = mkOption {
        type = types.package;
        default =  pkgs.vimPlugins.vim-commentary;
        description = "Plugin to use for vim-commentary";
      };
    };
  };

  config = mkIf cfg.enable {
    extraPlugins = [ cfg.package ];
  };
}
