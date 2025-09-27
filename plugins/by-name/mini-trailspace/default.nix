{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-trailspace";
  moduleName = "mini.trailspace";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    only_in_normal_buffers = false;
  };
}
