{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.plugins.intellitab;
  defs = import ../plugin-defs.nix { inherit pkgs; };
in
{
  options = {
    plugins.intellitab = {
      enable = mkEnableOption "intellitab.nvim";

      package = helpers.mkPackageOption "intellitab.nvim" pkgs.vimPlugins.intellitab-nvim;
    };
  };

  config = mkIf cfg.enable {
    extraPlugins = [ cfg.package ];

    maps.insert."<Tab>" = "<CMD>lua require([[intellitab]]).indent()<CR>";
    plugins.treesitter = {
      indent = true;
    };
  };
}
