{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "vscode-diff";
  package = "codediff-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    highlights = {
      line_insert = "#2a3325";
      line_delete = "#362c2e";
      char_insert = "#3d4f35";
      char_delete = "#4d3538";
    };
    keymaps = {
      view = {
        next_hunk = "]c";
        prev_hunk = "[c";
        next_file = "]f";
        prev_file = "[f";
      };
      explorer = {
        select = "<CR>";
        hover = "K";
        refresh = "R";
      };
    };
  };
}
