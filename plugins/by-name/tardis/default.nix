{ lib, ... }:

lib.nixvim.plugins.mkNeovimPlugin {
  name = "tardis";
  moduleName = "tardis-nvim";
  packPathName = "tardis.nvim";
  package = "tardis-nvim";
  description = ''
    Timetravel for neovim
  '';
  # TODO: Remove after https://github.com/NixOS/nixpkgs/pull/438707
  url = "https://github.com/FredeHoey/tardis.nvim";

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
