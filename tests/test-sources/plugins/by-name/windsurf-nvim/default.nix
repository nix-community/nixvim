{
  empty = {
    # FIXME: codeium auth error sometimes
    test.runNvim = false;
    plugins.windsurf-nvim = {
      enable = true;
      settings.enable_cmp_source = false;
    };
  };

  enabled-by-cmp = {
    # FIXME: codeium auth error sometimes
    test.runNvim = false;
    plugins.cmp = {
      enable = true;

      settings.sources = [ { name = "codeium"; } ];
    };
  };

  defaults = {
    # FIXME: codeium auth error sometimes
    test.runNvim = false;
    plugins = {
      cmp.enable = true;

      windsurf-nvim = {
        enable = true;

        settings = {
          manager_path.__raw = "nil";
          bin_path.__raw = "vim.fn.stdpath('cache') .. '/codeium/bin'";
          config_path.__raw = "vim.fn.stdpath('cache') .. '/codeium/config.json'";
          language_server_download_url = "https://github.com";
          api = {
            host = "server.codeium.com";
            port = "443";
            path = "/";
            portal_url = "codeium.com";
          };
          enterprise_mode.__raw = "nil";
          detect_proxy.__raw = "nil";
          tools.__empty = { };
          wrapper.__raw = "nil";
          enable_chat = true;
          enable_local_search = true;
          enable_index_service = true;
          search_max_workspace_file_count = 5000;
          file_watch_max_dir_count = 50000;
          enable_cmp_source = true;
          virtual_text = {
            enabled = false;
            filetypes.__empty = { };
            default_filetype_enabled = true;
            manual = false;
            idle_delay = 75;
            virtual_text_priority = 65535;
            map_keys = true;
            accept_fallback.__raw = "nil";
            key_bindings = {
              accept = "<Tab>";
              accept_word = false;
              accept_line = false;
              clear = false;
              next = "<M-]>";
              prev = "<M-[>";
            };
          };
          workspace_root = {
            use_lsp = true;
            find_root.__raw = "nil";
            paths = [
              ".bzr"
              ".git"
              ".hg"
              ".svn"
              "_FOSSIL_"
              "package.json"
            ];
          };
        };
      };
    };
  };
}
