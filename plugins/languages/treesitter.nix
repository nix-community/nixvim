{ pkgs, lib, config, ... }:
with lib;
let
  cfg = programs.nixvim.plugins.treesitter;
in
{
  options = {
    # TODO we need some treesitter configuration, all done in lua!
    programs.nixvim.plugins.treesitter = {
      enable = mkEnableOption "Enable treesitter highlighting";
    };
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      extraPlugins = [ pkgs.vimPlugins.nvim-treesitter ];
    };
  }
}
