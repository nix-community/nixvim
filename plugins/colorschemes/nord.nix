{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
helpers.vim-plugin.mkVimPlugin config {
  namespace = "colorschemes";
  name = "nord";
  originalName = "nord.nvim";
  defaultPackage = pkgs.vimPlugins.nord-nvim;
  globalPrefix = "nord_";

  maintainers = [lib.maintainers.GaetanLepage];

  # TODO introduced 2024-02-20: remove 2024-04-20
  deprecateExtraConfig = true;
  optionsRenamedToSettings = [
    "contrast"
    "borders"
    "disableBackground"
    "cursorlineTransparent"
    "enableSidebarBackground"
    "italic"
    "uniformDiffBackground"
  ];

  settingsOptions = {
    contrast = helpers.defaultNullOpts.mkBool false ''
      Make sidebars and popup menus like nvim-tree and telescope have a different background.
    '';

    borders = helpers.defaultNullOpts.mkBool false ''
      Enable the border between verticaly split windows visable.
    '';

    disable_background = helpers.defaultNullOpts.mkBool false ''
      Disable the setting of background color so that NeoVim can use your terminal background.
    '';

    cursorline_transparent = helpers.defaultNullOpts.mkBool false ''
      Set the cursorline transparent/visible.
    '';

    enable_sidebar_background = helpers.defaultNullOpts.mkBool false ''
      Re-enables the background of the sidebar if you disabled the background of everything.
    '';

    italic = helpers.defaultNullOpts.mkBool true ''
      Enables/disables italics.
    '';

    uniform_diff_background = helpers.defaultNullOpts.mkBool false ''
      Enables/disables colorful backgrounds when used in _diff_ mode.
    '';
  };

  settingsExample = {
    borders = true;
    disable_background = true;
    italic = false;
  };

  extraConfig = cfg: {
    colorscheme = "nord";
  };
}
