{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-fuzzy";
  moduleName = "mini.fuzzy";
  packPathName = "mini.fuzzy";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    cutoff = 50;
  };
}
