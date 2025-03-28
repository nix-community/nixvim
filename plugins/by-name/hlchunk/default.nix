{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "hlchunk";
  packPathName = "hlchunk.nvim";
  package = "hlchunk-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    priority = 15;
    style = [
      { fg = "#806d9c"; }
      { fg = "#c21f30"; }
    ];
    use_treesitter = true;
    chars = {
      horizontal_line = "─";
      vertical_line = "│";
      left_top = "╭";
      left_bottom = "╰";
      right_arrow = ">";
    };
    textobject = "";
    max_file_size = 1024 * 1024;
    error_sign = true;
    duration = 200;
    delay = 300;
  };
}
