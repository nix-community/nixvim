{
  lib,
  ...
}:
lib.nixvim.plugins.mkVimPlugin {
  name = "tagbar";
  globalPrefix = "tagbar_";

  maintainers = [ lib.maintainers.GaetanLepage ];

  # TODO introduced 2024-02-12: remove 2024-04-12
  deprecateExtraConfig = true;
  imports = [
    # TODO: added 2025-04-07, remove after 25.05
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "tagbar";
      packageName = "ctags";
      oldPackageName = "tags";
    })
  ];

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
