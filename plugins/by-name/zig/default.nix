{
  lib,
  ...
}:
with lib;
with lib.nixvim.plugins;
mkVimPlugin {
  name = "zig";
  package = "zig-vim";
  globalPrefix = "zig_";
  description = "Vim plugin for the Zig programming language.";

  maintainers = [ maintainers.GaetanLepage ];

  settingsOptions = {
    fmt_autosave = lib.nixvim.defaultNullOpts.mkFlagInt 1 ''
      This plugin enables automatic code formatting on save by default using zig fmt.
      To disable it, you can set this option to `0`.
    '';
  };

  settingsExample = {
    fmt_autosave = 0;
  };
}
