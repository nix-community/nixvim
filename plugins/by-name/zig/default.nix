{
  lib,
  helpers,
  ...
}:
with lib;
with lib.nixvim.vim-plugin;
mkVimPlugin {
  name = "zig";
  packPathName = "zig.vim";
  package = "zig-vim";
  globalPrefix = "zig_";

  maintainers = [ maintainers.GaetanLepage ];

  # TODO introduced 2024-03-02: remove 2024-05-02
  deprecateExtraConfig = true;
  optionsRenamedToSettings = [
    {
      old = "formatOnSave";
      new = "fmt_autosave";
    }
  ];

  settingsOptions = {
    fmt_autosave = helpers.defaultNullOpts.mkFlagInt 1 ''
      This plugin enables automatic code formatting on save by default using zig fmt.
      To disable it, you can set this option to `0`.
    '';
  };

  settingsExample = {
    fmt_autosave = 0;
  };
}
