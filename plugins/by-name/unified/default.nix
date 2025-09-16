{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "unified";
  packPathName = "unified.nvim";
  package = "unified-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsExample = {
    line_symbols = {
      add = "";
      delete = "󰊂";
      change = "";
    };
    auto_refresh = false;
  };
}
