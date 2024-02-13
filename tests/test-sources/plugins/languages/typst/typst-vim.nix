{
  empty = {
    plugins.typst-vim.enable = true;
  };

  example = {
    plugins.typst-vim = {
      enable = true;

      settings = {
        cmd = "typst";
        pdf_viewer = "zathura";
        conceal_math = false;
        auto_close_toc = false;
      };

      keymaps = {
        silent = true;
        watch = "<leader>w";
      };
    };
  };
}
