{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "fff";
  package = "fff-nvim";
  description = "A fast fuzzy file finder.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    base_path = lib.nixvim.nestedLiteralLua "vim.fn.getcwd()";
    max_results = 100;
    layout = {
      height = 0.8;
      width = 0.8;
      preview_position = "right";
    };
    key_bindings = {
      close = [
        "<Esc>"
        "<C-c>"
      ];
      select_file = "<CR>";
      open_split = "<C-s>";
      open_vsplit = "<C-v>";
      open_tab = "<C-t>";
      move_up = [
        "<Up>"
        "<C-p>"
      ];
      move_down = [
        "<Down>"
        "<C-n>"
      ];
    };
  };
}
