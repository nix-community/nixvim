{
  empty = {
    plugins.copilot-vim.enable = true;
  };

  example = {
    plugins.copilot-vim = {
      enable = true;

      settings = {
        filetypes = {
          "*" = false;
          python = true;
        };
        proxy = "localhost:3128";
        proxy_strict_ssl = false;
        workspace_folders = [ "~/Projects/myproject" ];
      };
    };
  };
}
