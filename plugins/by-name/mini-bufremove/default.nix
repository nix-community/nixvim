{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-bufremove";
  moduleName = "mini.bufremove";
  packPathName = "mini.bufremove";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    silent = true;
  };
}
