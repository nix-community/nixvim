{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.colorschemes.nord;
in {
  options = {
    colorschemes.nord = {
      enable = mkEnableOption "nord";

      package = helpers.mkPackageOption "nord.nvim" pkgs.vimPlugins.nord-nvim;

      contrast = helpers.defaultNullOpts.mkBool false ''
        Make sidebars and popup menus like nvim-tree and telescope have a different background.
      '';

      borders = helpers.defaultNullOpts.mkBool false ''
        Enable the border between verticaly split windows visable.
      '';

      disableBackground = helpers.defaultNullOpts.mkBool false ''
        Disable the setting of background color so that NeoVim can use your terminal background.
      '';

      cursorlineTransparent = helpers.defaultNullOpts.mkBool false ''
        Set the cursorline transparent/visible.
      '';

      enableSidebarBackground = helpers.defaultNullOpts.mkBool false ''
        Re-enables the background of the sidebar if you disabled the background of everything.
      '';

      italic = helpers.defaultNullOpts.mkBool true ''
        Enables/disables italics.
      '';

      uniformDiffBackground = helpers.defaultNullOpts.mkBool false ''
        Enables/disables colorful backgrounds when used in _diff_ mode.
      '';

      extraConfig = mkOption {
        type = types.attrs;
        description = ''
          The configuration options for vimtex without the 'nord_' prefix.
          Example: To set 'nord_foo_bar' to 1, write
            extraConfig = {
              foo_bar = true;
            };
        '';
        default = {};
      };
    };
  };

  config = mkIf cfg.enable {
    colorscheme = "nord";
    extraPlugins = [cfg.package];

    globals =
      mapAttrs'
      (name: value: nameValuePair "nord_${name}" value)
      (with cfg;
        {
          inherit
            contrast
            borders
            ;
          disable_background = disableBackground;
          cursorline_transparent = cursorlineTransparent;
          enable_sidebar_background = enableSidebarBackground;
          inherit italic;
          uniform_diff_background = uniformDiffBackground;
        }
        // cfg.extraConfig);
  };
}
