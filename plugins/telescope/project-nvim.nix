{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.plugins.telescope.extensions.project-nvim;
in
{
  options.plugins.telescope.extensions.project-nvim = {
    enable = mkEnableOption "project-nvim telescope extension";

  };

  config = mkIf cfg.enable {
    plugins.telescope.enabledExtensions = [ "projects" ];
  };
}
