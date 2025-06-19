{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "sqlite-lua";
  packPathName = "sqlite.lua";
  moduleName = "sqlite.lua";
  package = "sqlite-lua";
  description = "SQLite/LuaJIT binding and a highly opinionated wrapper for storing, retrieving, caching, and persisting SQLite databases.";

  maintainers = [ lib.maintainers.khaneliman ];

  callSetup = false;
  hasSettings = false;
}
