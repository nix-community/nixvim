{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.plugins.comment-nvim;
  defs = import ../plugin-defs.nix { inherit pkgs; };
in
{
  options = {
    plugins.intellitab = {
      enable = mkEnableOption "intellitab.nvim";
    };
  };

  config = mkIf cfg.enable {
    extraPlugins = [ defs.intellitab-nvim ];

    maps.insert."<Tab>" = "<CMD>lua require([[intellitab]]).indent()<CR>";
    plugins.treesitter = {
      indent = true;
    };
  };
}
