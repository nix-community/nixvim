{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-extra";
  moduleName = "mini.extra";
  packPathName = "mini.extra";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  hasSettings = false;
}
