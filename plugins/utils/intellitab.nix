{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.intellitab;
in {
  options = {
    plugins.intellitab = {
      enable = mkEnableOption "intellitab.nvim";

      package = helpers.mkPackageOption "intellitab.nvim" pkgs.vimPlugins.intellitab-nvim;
    };
  };

  config = mkIf cfg.enable {
    extraPlugins = [cfg.package];

    keymaps = [
      {
        mode = "i";
        key = "<Tab>";
        action = "require('intellitab').indent";
        lua = true;
      }
    ];
    plugins.treesitter = {
      indent = true;
    };
  };
}
