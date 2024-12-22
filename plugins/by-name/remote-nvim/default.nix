{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "remote-nvim";
  packPathName = "remote-nvim.nvim";
  package = "remote-nvim-nvim";

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
