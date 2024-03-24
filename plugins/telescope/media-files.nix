{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.telescope.extensions.media_files;
in {
  options.plugins.telescope.extensions.media_files = {
    enable = mkEnableOption "media_files extension for telescope";

    package = helpers.mkPackageOption "telescope extension media_files" pkgs.vimPlugins.telescope-media-files-nvim;

    filetypes = mkOption {
      default = null;
      type = with types; nullOr (listOf str);
    };

    find_cmd = mkOption {
      default = null;
      type = with types; nullOr str;
      example = ''"rg"'';
    };
  };

  config = mkIf cfg.enable {
    plugins.telescope = {
      enabledExtensions = ["media_files"];
    };

    extraPlugins = with pkgs.vimPlugins; [
      popup-nvim
      plenary-nvim
      cfg.package
    ];

    extraPackages = with pkgs; [
      ueberzug
    ];
  };
}
