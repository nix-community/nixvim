{
  empty = {
    plugins.typst-vim.enable = true;
  };

  example = {
    plugins.typst-vim = {
      enable = true;

      cmd = "typst";
      pdfViewer = "zathura";
      concealMath = false;
      autoCloseToc = false;
      keymaps = {
        silent = true;
        watch = "<leader>w";
      };
    };
  };
}
