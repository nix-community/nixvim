{ pkgs, config, lib, ... }:
with lib;
let 
  cfg = config.programs.nixvim.plugins.telescope.extensions.frecency;
in
{
  options.programs.nixvim.plugins.telescope.extensions.frecency = {
    enable = mkEnableOption "Enable frecency";
  };

  config = mkIf cfg.enable {
    programs.nixvim.extraPackages = [ pkgs.sqlite ];
    programs.nixvim.extraPlugins = with pkgs.vimPlugins; [ 
      telescope-frecency-nvim
      sqlite-lua
    ];

    programs.nixvim.plugins.telescope.enabledExtensions = [ "frecency" ];
  };
}
