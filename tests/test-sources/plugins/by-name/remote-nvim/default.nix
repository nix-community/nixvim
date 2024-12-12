{
  empty = {
    plugins.remote-nvim.enable = true;
  };

  defaults = {
    plugins.remote-nvim = {
      enable = true;

      settings = {
        devpod = {
          binary = "devpod";
          docker_binary = "docker";
          search_style = "current_dir_only";
          dotfiles = {
            path = null;
            install_script = null;
          };
          gpg_agent_forwarding = false;
          container_list = "running_only";
        };
        ssh_config = {
          ssh_binary = "ssh";
          scp_binary = "scp";
          ssh_config_file_paths = [ "$HOME/.ssh/config" ];

          ssh_prompts = [
            {
              match = "password:";
              type = "secret";
              value_type = "static";
              value = "";
            }
            {
              match = "continue connecting (yes/no/[fingerprint])?";
              type = "plain";
              value_type = "static";
              value = "";
            }
          ];
        };

        progress_view = {
          type = "popup";
        };

        offline_mode = {
          enabled = false;
          no_github = false;
        };

        remote = {
          app_name = "nvim";
          copy_dirs = {
            config = {
              base.__raw = ''vim.fn.stdpath("config")'';
              dirs = "*";
              compression = {
                enabled = false;
                additional_opts = { };
              };
            };
            data = {
              base.__raw = ''vim.fn.stdpath("data")'';
              dirs = { };
              compression = {
                enabled = true;
              };
            };
            cache = {
              base.__raw = ''vim.fn.stdpath("cache")'';
              dirs = { };
              compression = {
                enabled = true;
              };
            };
            state = {
              base.__raw = ''vim.fn.stdpath("state")'';
              dirs = { };
              compression = {
                enabled = true;
              };
            };
          };
        };

        client_callback.__raw = ''
          function(port, _)
              require("remote-nvim.ui").float_term(("nvim --server localhost:%s --remote-ui"):format(port), function(exit_code)
                if exit_code ~= 0 then
                  vim.notify(("Local client failed with exit code %s"):format(exit_code), vim.log.levels.ERROR)
                end
              end)
            end
        '';

        log = {
          level = "info";
          max_size = 1024 * 1024 * 2;
        };
      };
    };
  };

  example = {
    plugins.remote-nvim = {
      enable = true;

      settings = {
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
    };
  };
}
