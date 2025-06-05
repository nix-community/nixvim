{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-colors";
  moduleName = "mini.colors";
  packPathName = "mini.colors";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  hasSettings = false;
}
