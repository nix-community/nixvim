{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.intellitab;
in
{
  options = {
    plugins.intellitab = {
      enable = mkEnableOption "intellitab.nvim";

      package = lib.mkPackageOption pkgs "intellitab.nvim" {
        default = [
          "vimPlugins"
          "intellitab-nvim"
        ];
      };
    };
  };

  config = mkIf cfg.enable {
    extraPlugins = [ cfg.package ];

    keymaps = [
      {
        mode = "i";
        key = "<Tab>";
        action.__raw = "require('intellitab').indent";
      }
    ];
    plugins.treesitter = {
      settings.indent.enable = true;
    };
  };
}
