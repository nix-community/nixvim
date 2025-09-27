{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "remote-nvim";
  package = "remote-nvim-nvim";
  description = "Adds support for remote development and devcontainers to Neovim.";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsExample = {
    offline_mode = {
      enabled = true;
      no_github = true;
    };
    remote = {
      copy_dirs = {
        data = {
          base.__raw = ''vim.fn.stdpath ("data")'';
          dirs = [ "lazy" ];
          compression = {
            enabled = true;
            additional_opts = [ "--exclude-vcs" ];
          };
        };
      };
    };
  };
}
