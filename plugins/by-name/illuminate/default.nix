{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "illuminate";
  package = "vim-illuminate";
  setup = ".configure";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsExample = {
    delay = 200;
    providers = [
      "lsp"
      "treesitter"
    ];
    filetypes_denylist = [
      "dirbuf"
      "fugitive"
    ];
    under_cursor = false;
    min_count_to_highlight = 2;
  };

  # TODO: Deprecated 2025-10-04
  inherit (import ./deprecations.nix)
    optionsRenamedToSettings
    deprecateExtraOptions
    ;
}
