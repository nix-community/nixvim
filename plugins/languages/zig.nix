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
    description = "zig.vim";
    package = pkgs.vimPlugins.zig-vim;
    globalPrefix = "zig_";
    addExtraConfigRenameWarning = true;

    # Possibly add option to disable Treesitter highlighting if this is installed
    options = {
      formatOnSave = mkDefaultOpt {
        type = types.bool;
        global = "fmt_autosave";
        description = "Run zig fmt on save";
      };
    };
  }
