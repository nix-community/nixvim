{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "visual-whitespace";
  packPathName = "visual-whitespace.nvim";
  package = "visual-whitespace-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsExample = {
    enabled = true;
    match_types = {
      space = true;
      tab = true;
      nbsp = true;
      lead = true;
      trail = true;
    };
  };
}
