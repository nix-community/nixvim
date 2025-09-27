{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-statusline";
  moduleName = "mini.statusline";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    use_icons = false;
  };
}
