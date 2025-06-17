{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "vimade";
  description = "Vimade let's you dim, fade, tint, animate, and customize colors in your windows and buffers for Neovim.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    fadelevel = 0.7;
    recipe = [
      "duo"
      { animate = true; }
    ];
    tint = {
      bg = {
        rgb = [
          255
          255
          255
        ];
        intensity = 0.1;
      };
      fg = {
        rgb = [
          255
          255
          255
        ];
        intensity = 0.1;
      };
    };
  };
}
