{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "crates";
  packPathName = "crates.nvim";
  package = "crates-nvim";
  description = "A neovim plugin that helps managing crates.io dependencies.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  imports =
    [ { cmpSourcePlugins.crates = "crates"; } ]
    ++
    # TODO introduced 2024-12-12: remove after 25.05
    lib.nixvim.mkSettingsRenamedOptionModules [ "plugins" "crates-nvim" ]
      [ "plugins" "crates" ]
      [
        "enable"
        "package"
        {
          old = "extraOptions";
          new = "settings";
        }
      ];

  settingsOptions = { };

  settingsExample = {
    smart_insert = true;
    autoload = true;
    autoupdate = true;
  };
}
