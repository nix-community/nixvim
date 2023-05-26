{
  empty = {
    plugins.typst-vim.enable = true;
  };

  example = {
    plugins.typst-vim = {
      enable = true;

      keymaps = {
        silent = true;

        watch = "<leader>w";
      };
    };
  };
}
