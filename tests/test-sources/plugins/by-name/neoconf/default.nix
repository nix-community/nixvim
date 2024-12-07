{
  empty = {
    plugins.neoconf.enable = true;
  };

  defaults = {
    plugins.neoconf = {
      enable = true;

      settings = {
        local_settings = ".neoconf.json";
        global_settings = "neoconf.json";
        import = {
          vscode = true;
          coc = true;
          lsp = true;
        };
        live_reload = true;
        filetype_jsonc = true;
        plugins = {
          lspconfig = {
            enabled = true;
          };
          jsonls = {
            enabled = true;
            configured_servers_only = true;
          };
          lua_ls = {
            enabled_for_neovim_config = true;
            enabled = false;
          };
        };
      };
    };
  };

  example = {
    plugins.neoconf = {
      enable = true;

      settings = {
        local_settings = ".neoconf.example.json";
        global_settings = "neoconf-example.json";
        import = {
          vscode = false;
          coc = true;
          lsp = false;
        };
        live_reload = false;
        filetype_jsonc = false;
        plugins = {
          lspconfig = {
            enabled = false;
          };
          jsonls = {
            enabled = true;
            configured_servers_only = false;
          };
          lua_ls = {
            enabled_for_neovim_config = false;
            enabled = true;
          };
        };
      };
    };
  };
}
