{
  empty = {
    plugins = {
      rest.enable = true;
      treesitter.enable = true;
    };
  };

  defaults = {
    plugins = {
      treesitter.enable = true;
      rest = {
        enable = true;

        settings = {
          custom_dynamic_variables = { };
          request = {
            skip_ssl_verification = false;
            hooks = {
              encode_url = true;
              user_agent.__raw = ''"rest.nvim v" .. require("rest-nvim.api").VERSION'';
              set_content_type = true;
            };
          };
          response = {
            hooks = {
              decode_url = true;
              format = true;
            };
          };
          clients = {
            curl = {
              statistics = [
                {
                  id = "time_total";
                  winbar = "take";
                  title = "Time taken";
                }
                {
                  id = "size_download";
                  winbar = "size";
                  title = "Download size";
                }
              ];
              opts = {
                set_compressed = false;
              };
            };
          };
          cookies = {
            enable = true;
            path.__raw = ''vim.fs.joinpath(vim.fn.stdpath("data") --[[@as string]], "rest-nvim.cookies")'';
          };
          env = {
            enable = true;
            pattern = ".*%.env.*";
          };
          ui = {
            winbar = true;
            keybinds = {
              prev = "H";
              next = "L";
            };
          };
          highlight = {
            enable = true;
            timeout = 750;
          };
          _log_level.__raw = ''vim.log.levels.WARN'';
        };
      };
    };
  };

  telescope = {
    plugins = {
      rest = {
        enable = true;
        enableTelescope = true;
      };
      treesitter.enable = true;
      telescope.enable = true;
      web-devicons.enable = true;
    };
  };
}
