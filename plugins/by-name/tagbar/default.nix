{
  lib,
  ...
}:
lib.nixvim.plugins.mkVimPlugin {
  name = "tagbar";
  globalPrefix = "tagbar_";
  description = "Vim plugin that displays tags in a window, ordered by scope.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  dependencies = [ "ctags" ];

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
