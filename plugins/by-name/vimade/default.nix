{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "vimade";

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
