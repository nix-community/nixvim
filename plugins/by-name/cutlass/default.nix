{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "cutlass-nvim";
  moduleName = "cutlass";
  packPathName = "cutlass.nvim";

  maintainers = [ lib.maintainers.saygo-png ];

  settingsExample = {
    override_del = true;
    exclude = [
      "ns"
      "nS"
      "nx"
      "nX"
      "nxx"
      "nX"
    ];
    registers = {
      select = "s";
      delete = "d";
      change = "c";
    };
  };
}
