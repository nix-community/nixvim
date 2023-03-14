{
  empty = {
    plugins.lsp.enable = true;
  };

  test = {
    plugins.lsp = {
      enable = true;

      keymaps = {
        silent = true;
        diagnostic = {
          "<leader>k" = "goto_prev";
          "<leader>j" = "goto_next";
        };

        lspBuf = {
          "gd" = "definition";
          "gD" = "references";
          "gt" = "type_definition";
          "gi" = "implementation";
          "K" = "hover";
        };
      };

      servers = {
        bashls.enable = true;
        clangd.enable = true;
        nil_ls.enable = true;
        rust-analyzer.enable = true;
        pylsp = {
          enable = true;
          filetypes = ["python"];
          autostart = false;
        };
      };
    };
  };
}
