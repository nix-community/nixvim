{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-align";
  moduleName = "mini.align";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    silent = true;
  };
}
