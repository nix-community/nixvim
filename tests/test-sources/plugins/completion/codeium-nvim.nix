{
  empty = {
    plugins.codeium-nvim.enable = true;
  };

  enabled-by-cmp = {
    plugins.cmp = {
      enable = true;

      settings.sources = [ { name = "codeium"; } ];
    };
  };

  defaults = {
    plugins.codeium-nvim = {
      enable = true;

      settings = {
        manager_path = null;
        bin_path.__raw = "vim.fn.stdpath('cache') .. '/codeium/bin'";
        config_path.__raw = "vim.fn.stdpath('cache') .. '/codeium/config.json'";
        language_server_download_url = "https://github.com";
        api = {
          host = "server.codeium.com";
          port = "443";
        };
        enterprise_mode = null;
        detect_proxy = null;
        tools = { };
        wrapper = null;
        enable_chat = false;
        enable_local_search = false;
        enable_index_service = false;
        search_max_workspace_file_count = 5000;
      };
    };
  };
}
