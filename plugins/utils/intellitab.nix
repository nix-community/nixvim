{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.nixvim.plugins.comment-nvim;
  helpers = import ../helpers.nix { inherit lib; };
in
{
  options = {
    programs.nixvim.plugins.intellitab = {
      enable = mkEnableOption "intellitab.nvim";
    };
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      maps.insert."<Tab>" = "<CMD>lua require([[intellitab]]).indent()<CR>";
      plugins.packer = {
        enable = true;
        plugins = [ "pta2002/intellitab.nvim" ];
      };

      plugins.treesitter = {
        indent = true;
      };
    };
  };
}
