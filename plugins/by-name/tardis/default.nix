{ lib, ... }:

lib.nixvim.plugins.mkNeovimPlugin {
  name = "tardis";
  moduleName = "tardis-nvim";
  packPathName = "tardis.nvim";
  package = "tardis-nvim";
  description = ''
    Timetravel for neovim
  '';
  # FIXME: This shouldn't be necessary as meta.homepage is defined in nixpkgs.
  # see https://github.com/nix-community/nixvim/pull/3648#issuecomment-3239438693
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
