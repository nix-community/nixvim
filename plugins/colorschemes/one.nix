{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.colorschemes.one;
in
{
  options = {
    colorschemes.one = {
      enable = mkEnableOption "Enable vim-one";

      package = mkOption {
        type = types.package;
        default = pkgs.vimPlugins.vim-one;
        description = "Plugin to use for one";
      };
    };
  };

  config = mkIf cfg.enable {
    colorscheme = "one";
    extraPlugins = [ cfg.package ];

    options = {
      termguicolors = true;
    };
  };
}
