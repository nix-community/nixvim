{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-hues";
  moduleName = "mini.hues";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    background = "#351721";
    foreground = "#cdc4c6";
    n_hues = 8;
    saturation = "medium";
    accent = "bg";
    plugins.default = true;
    autoadjust = true;
  };
}
