{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "visual-multi";
  packPathName = "vim-visual-multi";
  package = "vim-visual-multi";
  globalPrefix = "VM_";
  description = "Multiple cursors plugin for vim/neovim.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = import ./settings-options.nix lib;

  settingsExample = {
    mouse_mappings = 1;
    silent_exit = 0;
    show_warnings = 1;
    default_mappings = 1;
    maps = {
      "Select All" = "<C-M-n>";
      "Add Cursor Down" = "<M-Down>";
      "Add Cursor Up" = "<M-Up>";
      "Mouse Cursor" = "<M-LeftMouse>";
      "Mouse Word" = "<M-RightMouse>";
    };
  };
}
