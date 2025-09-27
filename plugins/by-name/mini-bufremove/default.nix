{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-bufremove";
  moduleName = "mini.bufremove";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    silent = true;
  };
}
