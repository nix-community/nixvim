{
  lib,
  config,
  helpers,
  pkgs,
  ...
}:
with lib;
with helpers.vim-plugin;
  mkVimPlugin config {
    name = "zig";
    originalName = "zig.vim";
    defaultPackage = pkgs.vimPlugins.zig-vim;
    globalPrefix = "zig_";
    deprecateExtraConfig = true;

    # Possibly add option to disable Treesitter highlighting if this is installed
    options = {
      formatOnSave = mkDefaultOpt {
        type = types.bool;
        global = "fmt_autosave";
        description = "Run zig fmt on save";
      };
    };
  }
