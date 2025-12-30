{
  empty = {
    plugins.codesettings.enable = true;
  };

  defaults = {
    plugins.codesettings = {
      enable = true;

      settings = {
        config_file_paths = [
          ".vscode/settings.json"
          "codesettings.json"
          "lspsettings.json"
        ];
        jsonc_filetype = true;
        jsonls_integration = true;
        live_reload = false;
        loader_extensions = [ ];
        lua_ls_integration = true;
        merge_lists = "append";
        root_dir.__raw = "nil";
      };
    };
  };

  example = {
    plugins.codesettings = {
      enable = true;

      settings = {
        config_file_paths = [
          ".vscode/settings.json"
          "codesettings.json"
          "lspsettings.json"
          ".codesettings.json"
          ".lspsettings.json"
          ".nvim/codesettings.json"
          ".nvim/lspsettings.json"
        ];
        jsonls_integration = true;
        default_merge_opts = {
          list_behavior = "prepend";
        };
      };
    };
  };
}
