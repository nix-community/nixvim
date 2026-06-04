{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "conflict";
  package = "conflict-nvim";
  description = "A simple Neovim plugin to resolve merge conflicts with ease.";

  maintainers = [ lib.maintainers.jaredmontoya ];

  dependencies = [ "git" ];

  settingsExample = {
    default_mappings = {
      current = "<leader>co";
      incoming = "<leader>ct";
      both = "<leader>ca";
      base = "<leader>cb";
      none = "<leader>cn";
      next = "]e";
      prev = "[e";
    };
    show_actions = false;
    disable_diagnostics = false;
    highlights = {
      current = "DiffChange";
      incoming = "DiffText";
      ancestor = "DiffDelete";
    };
  };
}
