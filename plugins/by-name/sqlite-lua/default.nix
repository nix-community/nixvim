{
  lib,
  ...
}:
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "sqlite-lua";
  originalName = "sqlite.lua";
  luaName = "sqlite.lua";
  package = "sqlite-lua";

  maintainers = [ lib.maintainers.khaneliman ];

  callSetup = false;
  hasSettings = false;
}
