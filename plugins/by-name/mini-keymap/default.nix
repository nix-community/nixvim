{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-keymap";
  moduleName = "mini.keymap";
  packPathName = "mini.keymap";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  hasSettings = false;
}
