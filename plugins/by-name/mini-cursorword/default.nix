{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-cursorword";
  moduleName = "mini.cursorword";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    delay = 50;
  };
}
