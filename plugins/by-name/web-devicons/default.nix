{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "web-devicons";
  originalName = "nvim-web-devicons";
  luaName = "nvim-web-devicons";
  package = "nvim-web-devicons";

  maintainers = [ lib.maintainers.refaelsh ];

  settingsExample = {
    color_icons = true;
    strict = true;
  };
}
