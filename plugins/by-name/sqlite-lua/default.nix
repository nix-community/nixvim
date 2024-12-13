{
  lib,
  ...
}:
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "sqlite-lua";
  packPathName = "sqlite.lua";
  luaName = "sqlite.lua";
  package = "sqlite-lua";

  maintainers = [ lib.maintainers.khaneliman ];

  callSetup = false;
  hasSettings = false;
}
