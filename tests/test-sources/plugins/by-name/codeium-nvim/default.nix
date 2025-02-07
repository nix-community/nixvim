{
  empty = {
    plugins.codeium-nvim = {
      enable = true;
      cmp.enable = false;
      settings.enable_cmp_source = false;
    };
  };

  enabled-by-cmp = {
    plugins = {
      cmp.enable = true;
      codeium-nvim = {
        enable = true;
        settings.enable_cmp_source = false;
      };
    };
  };

  defaults = {
    plugins = {
      cmp.enable = true;

      codeium-nvim = {
        enable = true;

        settings = {
          manager_path = null;
          bin_path.__raw = "vim.fn.stdpath('cache') .. '/codeium/bin'";
          config_path.__raw = "vim.fn.stdpath('cache') .. '/codeium/config.json'";
          language_server_download_url = "https://github.com";
          api = {
            host = "server.codeium.com";
            port = "443";
            path = "/";
            portal_url = "codeium.com";
          };
          enterprise_mode = null;
          detect_proxy = null;
          tools = { };
          wrapper = null;
          enable_chat = true;
          enable_local_search = true;
          enable_index_service = true;
          search_max_workspace_file_count = 5000;
          file_watch_max_dir_count = 50000;
          enable_cmp_source = true;
          virtual_text = {
            enabled = false;
            filetypes = [ ];
            default_filetype_enabled = true;
            manual = false;
            idle_delay = 75;
            virtual_text_priority = 65535;
            map_keys = true;
            accept_fallback = null;
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
            find_root = null;
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
