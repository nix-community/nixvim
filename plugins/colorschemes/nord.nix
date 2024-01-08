{
  lib,
  pkgs,
  ...
} @ args:
with lib;
with import ../helpers.nix {inherit lib;};
  mkPlugin args {
    name = "nord";
    description = "nord.nvim";
    package = pkgs.vimPlugins.nord-nvim;
    globalPrefix = "nord_";

    options = {
      contrast = mkDefaultOpt {
        type = types.bool;
        description = ''
          Make sidebars and popup menus like nvim-tree and telescope have a different background.
        '';
      };

      borders = mkDefaultOpt {
        type = types.bool;
        description = "Enable the border between verticaly split windows visable.";
      };

      disable_background = mkDefaultOpt {
        type = types.bool;
        description = ''
          Disable the setting of background color so that NeoVim can use your terminal background.
        '';
      };

      cursorline_transparent = mkDefaultOpt {
        type = types.bool;
        description = "Set the cursorline transparent/visible.";
      };

      enable_sidebar_background = mkDefaultOpt {
        type = types.bool;
        description = ''
          Re-enables the background of the sidebar if you disabled the background of everything.
        '';
      };

      italic = mkDefaultOpt {
        type = types.bool;
        description = "Enables/disables italics.";
      };
    };
  }
