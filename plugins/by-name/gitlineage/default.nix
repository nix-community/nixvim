{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "gitlineage";
  moduleName = "gitlineage";

  description = "Show git lineage information inside Neovim.";

  maintainers = [ lib.maintainers.LionyxML ];

  settingsExample = {
    split = "auto";
    keymap = "<leader>gl";
    keys = {
      close = "q";
      next_commit = "]c";
      prev_commit = "[c";
      yank_commit = "yc";
      open_diff = "<CR>";
    };
  };
}
