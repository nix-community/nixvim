{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-tabline";
  moduleName = "mini.tabline";
  packPathName = "mini.tabline";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    show_icons = false;
    tabpage_section = "right";
  };
}
