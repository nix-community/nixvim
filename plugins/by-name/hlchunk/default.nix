{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "hlchunk";
  packPathName = "hlchunk.nvim";
  package = "hlchunk-nvim";
  description = "A plugin that can highlight the indent line, and highlight the code chunk according to the current cursor position.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    chunk = {
      enable = true;
      use_treesitter = true;
      style.fg = "#91bef0";
      exclude_filetypes = {
        neo-tree = true;
        lazyterm = true;
      };
      chars = {
        horizontal_line = "─";
        vertical_line = "│";
        left_top = "╭";
        left_bottom = "╰";
        right_arrow = "─";
      };
    };
    indent = {
      chars = [ "│" ];
      use_treesitter = false;

      style.fg = "#45475a";
      exclude_filetypes = {
        neo-tree = true;
        lazyterm = true;
      };
    };
    blank.enable = false;
    line_num = {
      use_treesitter = true;
      style = "#91bef0";
    };
  };
}
