{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mkdnflow";
  package = "mkdnflow-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsExample = {
    modules = {
      bib = false;
      yaml = true;
    };
    create_dirs = false;
    perspective = {
      priority = "root";
      root_tell = ".git";
    };
    links = {
      style = "wiki";
      conceal = true;
    };
    to_do = {
      symbols = [
        "✗"
        "◐"
        "✓"
      ];
    };
  };

  # TODO: Deprecated 2025-10-04
  inherit (import ./deprecations.nix)
    optionsRenamedToSettings
    deprecateExtraOptions
    ;
}
