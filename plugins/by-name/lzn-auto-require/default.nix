{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "lzn-auto-require";
  description = ''
    Auto load optional plugins via lua modules with `lz.n`.

    This plugin overrides the `require` function to also search for plugins in
    `{packpath}/*/opt` and load them using `lz.n`.
  '';

  hasSettings = false;
  setup = ".enable";
  configLocation = lib.mkOrder 5000 "extraConfigLuaPost"; # Register after everything to catch mistates

  maintainers = [ lib.maintainers.axka ];
}
