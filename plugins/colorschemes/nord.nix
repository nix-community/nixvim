{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.vim-plugin.mkVimPlugin {
  name = "nord";
  isColorscheme = true;
  originalName = "nord.nvim";
  defaultPackage = pkgs.vimPlugins.nord-nvim;
  globalPrefix = "nord_";

  maintainers = [ lib.maintainers.GaetanLepage ];

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
    contrast = defaultNullOpts.mkBool false ''
      Make sidebars and popup menus like nvim-tree and telescope have a different background.
    '';

    borders = defaultNullOpts.mkBool false ''
      Enable the border between vertically split windows.
    '';

    disable_background = defaultNullOpts.mkBool false ''
      Disable the setting of background color so that NeoVim can use your terminal background.
    '';

    cursorline_transparent = defaultNullOpts.mkBool false ''
      Set the cursorline transparent/visible.
    '';

    enable_sidebar_background = defaultNullOpts.mkBool false ''
      Re-enables the background of the sidebar if you disabled the background of everything.
    '';

    italic = defaultNullOpts.mkBool true ''
      Enables/disables italics.
    '';

    uniform_diff_background = defaultNullOpts.mkBool false ''
      Enables/disables colorful backgrounds when used in _diff_ mode.
    '';
  };

  settingsExample = {
    borders = true;
    disable_background = true;
    italic = false;
  };
}
