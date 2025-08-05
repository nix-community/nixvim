{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "colorful-winsep";
  packPathName = "colorful-winsep.nvim";
  package = "colorful-winsep-nvim";

  maintainers = [ lib.maintainers.saygo-png ];

  settingsExample = {
    hi = {
      bg = "#7d8618";
      fg = "#b8bb26";
    };
    only_line_seq = true;
    no_exec_files = [
      "packer"
      "TelescopePrompt"
      "mason"
      "CompetiTest"
      "NvimTree"
    ];
    symbols = [
      "━"
      "┃"
      "┏"
      "┓"
      "┗"
      "┛"
    ];
  };
}
