{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-pairs";
  moduleName = "mini.pairs";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    modes = {
      insert = true;
      command = true;
      terminal = false;
    };
  };
}
