{ lib, ... }:

lib.nixvim.plugins.mkNeovimPlugin {
  name = "tardis";
  moduleName = "tardis-nvim";
  package = "tardis-nvim";
  description = ''
    Timetravel for neovim
  '';

  maintainers = [ lib.maintainers.fredeb ];

  settingsExample = {
    keymap = {
      next = "<C-j>";
      prev = "<C-k>";
      quit = "q";
      revision_message = "<C-m>";
      commit = "<C-g>";
    };
    settings = {
      initial_revisions = 10;
      max_revisions = 256;
      show_commit_index = false;
    };
  };
}
