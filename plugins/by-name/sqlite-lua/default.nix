{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "sqlite-lua";
  packPathName = "sqlite.lua";
  moduleName = "sqlite.lua";
  package = "sqlite-lua";

  maintainers = [ lib.maintainers.khaneliman ];

  callSetup = false;
  hasSettings = false;
}
