{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.plugins.trouble;
  helpers = import ../helpers.nix {inherit lib;};
in
  with lib;
  # with helpers;
    {
      options.plugins.trouble = {
        enable = mkEnableOption "trouble.nvim";

        package = helpers.mkPackageOption "trouble-nvim" pkgs.vimPlugins.trouble-nvim;

        position = helpers.mkNullOrOption (types.enum ["top" "left" "right" "bottom"]) "Position of the list";
        height = helpers.mkNullOrOption types.int "Height of the trouble list when position is top or bottom";
        width = helpers.mkNullOrOption types.int "Width of the trouble list when position is left or right";
        icons = helpers.mkNullOrOption types.bool "Use devicons for filenames";
      };

      config = mkIf cfg.enable {
        extraPlugins = with pkgs.vimPlugins; [
          cfg.package
          nvim-web-devicons
        ];
      };
    }
