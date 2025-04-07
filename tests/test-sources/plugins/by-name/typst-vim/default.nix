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
        conceal_math = 0;
        auto_close_toc = 0;
      };

      keymaps = {
        silent = true;
        watch = "<leader>w";
      };
    };
  };

  no-packages = {
    plugins.typst-vim.enable = true;
    dependencies.typst.enable = false;
  };
}
