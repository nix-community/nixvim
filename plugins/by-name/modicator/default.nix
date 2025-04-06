{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "modicator";
  packPathName = "modicator.nvim";
  package = "modicator-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  extraConfig = {
    opts = {
      termguicolors = lib.mkDefault true;
      cursorline = lib.mkDefault true;
      number = lib.mkDefault true;
    };
  };

  settingsExample = {
    show_warnings = true;
    highlights = {
      defaults = {
        bold = false;
        italic = false;
      };
    };
  };
}
