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
    };
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      extraPlugins = [ pkgs.vimPlugins.vim-commentary ];
    };
  };
}
