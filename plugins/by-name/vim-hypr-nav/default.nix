{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "vim-hypr-nav";
  description = "Seamless navigation between hyprland windows and (Neo)Vim splits with the same key bindings.";
  url = "https://github.com/nuchs/vim-hypr-nav";
  maintainers = [ ];

  hasSettings = false;
  callSetup = false;
}
