{
  empty = {
    plugins.copilot-vim.enable = true;
  };

  example = {
    plugins.copilot-vim = {
      enable = true;

      filetypes = {
        "*" = false;
        python = true;
      };

      proxy = "localhost:3128";
    };
  };
}
