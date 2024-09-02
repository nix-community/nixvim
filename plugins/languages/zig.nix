{
  lib,
  helpers,
  pkgs,
  ...
}:
with lib;
with helpers.vim-plugin;
mkVimPlugin {
  name = "zig";
  originalName = "zig.vim";
  defaultPackage = pkgs.vimPlugins.zig-vim;
  globalPrefix = "zig_";

  maintainers = [ maintainers.GaetanLepage ];

  # TODO introduced 2024-03-02: remove 2024-05-02
  deprecateExtraConfig = true;
  imports = [
    (mkRenamedOptionModule
      [
        "plugins"
        "zig"
        "formatOnSave"
      ]
      [
        "plugins"
        "zig"
        "settings"
        "fmt_autosave"
      ]
    )
  ];

  settingsOptions = {
    fmt_autosave = helpers.defaultNullOpts.mkBool true ''
      This plugin enables automatic code formatting on save by default using zig fmt.
      To disable it, you can set this option to `false`.
    '';
  };

  settingsExample = {
    fmt_autosave = false;
  };
}
