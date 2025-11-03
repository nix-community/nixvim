{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-jump";
  moduleName = "mini.jump";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    mappings = {
      forward = "f";
      backward = "F";
      forward_till = "t";
      backward_till = "T";
      repeat_jump = ";";
    };

    delay = {
      highlight = 250;
      idle_stop = 10000000;
    };

    silent = false;
  };
}
