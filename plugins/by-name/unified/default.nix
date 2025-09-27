{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "unified";
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
