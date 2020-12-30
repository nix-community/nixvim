{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.programs.nixvim.plugins.lightline;
in {
  options = {
    programs.nixvim.plugins.lightline = {
      enable = mkEnableOption "Enable lightline";

      colorscheme = mkOption {
        type = types.str;
        default = config.programs.nixvim.colorscheme;
        description = "The colorscheme to use for lightline. Defaults to .colorscheme.";
        example = "gruvbox";
      };
    };
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      extraPlugins = [ pkgs.vimPlugins.lightline-vim ];
      extraConfigVim = ''
        """ lightline {{{
        let g:lightline = { 'colorscheme': '${cfg.colorscheme}' }
        """ }}}
      '';
    };
  };
}
