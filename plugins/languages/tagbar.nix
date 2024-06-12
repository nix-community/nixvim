{
  helpers,
  config,
  pkgs,
  lib,
  ...
}:
helpers.vim-plugin.mkVimPlugin config {
  name = "tagbar";
  defaultPackage = pkgs.vimPlugins.tagbar;
  globalPrefix = "tagbar_";
  extraPackages = [ pkgs.ctags ];

  maintainers = [ lib.maintainers.GaetanLepage ];

  # TODO introduced 2024-02-12: remove 2024-04-12
  deprecateExtraConfig = true;

  settingsExample = {
    position = "right";
    autoclose = false;
    autofocus = false;
    foldlevel = 2;
    autoshowtag = true;
    iconchars = [
      ""
      ""
    ];
    visibility_symbols = {
      public = "󰡭 ";
      protected = "󱗤 ";
      private = "󰛑 ";
    };
  };
}
