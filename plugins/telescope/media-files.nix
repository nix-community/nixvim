{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.plugins.telescope.extensions.media_files;
in
{
  options.plugins.telescope.extensions.media_files = {
    enable = mkEnableOption "Enable media_files extension for telescope";

    filetypes = mkOption {
      default = types.null;
      type = with types; nullOr (listOf str);
    };

    find_cmd = mkOption {
      default = null;
      type = with types; nullOr str;
      example = ''"rg"'';
    };
  };

  config = mkIf cfg.enable {
    plugins.telescope.enabledExtensions = [ "media_files" ];

    extraPlugins = with pkgs.vimPlugins; [
      popup-nvim
      plenary-nvim
      telescope-media-files-nvim
    ];

    extraPackages = with pkgs; [
      ueberzug
    ];
  };
}
