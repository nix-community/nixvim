{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "crates";
  package = "crates-nvim";
  description = "A neovim plugin that helps managing crates.io dependencies.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  imports = [
    { cmpSourcePlugins.crates = "crates"; }
  ];

  settingsOptions = { };

  settingsExample = {
    smart_insert = true;
    autoload = true;
    autoupdate = true;
  };
}
