{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "inc-rename";
  moduleName = "inc_rename";
  package = "inc-rename-nvim";
  description = ''
    A small Neovim plugin that provides a command for LSP renaming with
    immediate visual feedback thanks to Neovim's command preview feature.
  '';

  maintainers = [ lib.maintainers.jolars ];

  settingsExample = {
    cmd_name = "IncRename";
    hl_group = "Substitute";
    input_buffer_type = "snacks";
    preview_empty_name = false;
    show_message = true;
  };
}
