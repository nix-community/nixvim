{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "lzn-auto-require";

  setup = ".enable";
  configLocation = lib.mkAfter "extraConfigLuaPost"; # Register after everything to catch mistates

  maintainers = [ lib.maintainers.axka ];
}
