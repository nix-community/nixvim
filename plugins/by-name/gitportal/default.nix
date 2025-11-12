{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "gitportal";
  package = "gitportal-nvim";

  description = "Bridges Neovim and Git hosting platforms, enabling users to open files in browser and open Git permalinks in Neovim.";

  maintainers = [ lib.maintainers.phinze ];

  settingsExample = {
    always_include_current_line = true;
    default_remote = "upstream";
    switch_branch_or_commit_upon_ingestion = "ask_first";
  };
}
