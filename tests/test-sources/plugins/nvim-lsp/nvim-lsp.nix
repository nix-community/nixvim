{
  empty = {
    plugins.lsp.enable = true;
  };

  example = {
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

  all-servers = {
    plugins.lsp = {
      enable = true;

      servers = {
        astro.enable = true;
        bashls.enable = true;
        clangd.enable = true;
        cssls.enable = true;
        dartls.enable = true;
        denols.enable = true;
        eslint.enable = true;
        elixirls.enable = true;
        gopls.enable = true;
        hls.enable = true;
        html.enable = true;
        jsonls.enable = true;
        lua-ls.enable = true;
        nil_ls.enable = true;
        pylsp.enable = true;
        pyright.enable = true;
        rnix-lsp.enable = true;
        rust-analyzer.enable = true;
        tailwindcss.enable = true;
        texlab.enable = true;
        tsserver.enable = true;
        vuels.enable = true;
        # zls.enable = true; Broken as of 03/17/2023
      };
    };
  };
}
