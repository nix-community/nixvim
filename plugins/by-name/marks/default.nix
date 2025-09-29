{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "marks";
  package = "marks-nvim";
  description = "A better user experience for viewing and interacting with Neovim marks.";
  maintainers = [ ];

  settingsExample = {
    cyclic = true;
    refreshInterval = 150;
    mappings = {
      set = "<Leader>mM";
      delete = "<Leader>md";
      next = "<Leader>mn";
      prev = "<Leader>mp";
      toggle = "<Leader>mm";
      delete_buf = "<Leader>mc";
      delete_line = "<Leader>mD";
    };
  };

  # TODO: introduced 2025-09-29: remove after 26.05
  inherit (import ./deprecations.nix lib) deprecateExtraOptions optionsRenamedToSettings imports;
}
