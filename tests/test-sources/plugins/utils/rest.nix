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
          client = "curl";
          env_file = ".env";
          env_pattern = "\\.env$";
          env_edit_command = "tabedit";
          encode_url = true;
          skip_ssl_verification = false;
          custom_dynamic_variables = { };
          logs = {
            level = "info";
            save = true;
          };
          result = {
            split = {
              horizontal = false;
              in_place = false;
              stay_in_current_window_after_split = true;
            };
            behavior = {
              show_info = {
                url = true;
                headers = true;
                http_info = true;
                curl_command = true;
              };
              decode_url = true;
              statistics = {
                enable = true;
                stats = [
                  {
                    __unkeyed = "total_time";
                    title = "Time taken:";
                  }
                  {
                    __unkeyed = "size_download_t";
                    title = "Download size:";
                  }
                ];
              };
              formatters = {
                json = "jq";
                html.__raw = ''
                  function(body)
                    if vim.fn.executable("tidy") == 0 then
                      return body, { found = false, name = "tidy" }
                    end
                    local fmt_body = vim.fn.system({
                      "tidy",
                      "-i",
                      "-q",
                      "--tidy-mark",      "no",
                      "--show-body-only", "auto",
                      "--show-errors",    "0",
                      "--show-warnings",  "0",
                      "-",
                    }, body):gsub("\n$", "")

                    return fmt_body, { found = true, name = "tidy" }
                  end
                '';
              };
            };
            keybinds = {
              buffer_local = false;
              prev = "H";
              next = "L";
            };
          };
          highlight = {
            enable = true;
            timeout = 750;
          };
          keybinds = [
            [
              "<localleader>rr"
              "<cmd>Rest run<cr>"
              "Run request under the cursor"
            ]
            [
              "<localleader>rl"
              "<cmd>Rest run last<cr>"
              "Re-run latest request"
            ]
          ];
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
