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
        clangd = {
          enable = true;
          onAttach.function = ''
            print('The clangd language server has been attached !')
          '';
        };
        # Do not install the language server using nixvim
        gopls = {
          enable = true;
          installLanguageServer = false;
        };
        nil_ls.enable = true;
        rust-analyzer.enable = true;
        ruff-lsp = {
          enable = true;
          extraOptions = {
            init_options.settings.args = ["--config=/path/to/config.toml"];
          };
        };
        pylsp = {
          enable = true;
          filetypes = ["python"];
          autostart = false;
        };
        # rootDir
        typst-lsp = {
          enable = true;
          rootDir = ''
            require 'lspconfig.util'.root_pattern('.git', 'main.typ')
          '';
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
        clojure-lsp.enable = true;
        cssls.enable = true;
        dartls.enable = true;
        denols.enable = true;
        eslint.enable = true;
        elixirls.enable = true;
        futhark-lsp.enable = true;
        gopls.enable = true;
        hls.enable = true;
        html.enable = true;
        jsonls.enable = true;
        julials.enable = true;
        lua-ls.enable = true;
        metals.enable = true;
        nil_ls.enable = true;
        pylsp.enable = true;
        pyright.enable = true;
        rnix-lsp.enable = true;
        ruff-lsp.enable = true;
        rust-analyzer.enable = true;
        sourcekit.enable = true;
        tailwindcss.enable = true;
        terraformls.enable = true;
        texlab.enable = true;
        tsserver.enable = true;
        typst-lsp.enable = true;
        vuels.enable = true;
        yamlls.enable = true;
        zls.enable = true;
      };
    };
  };
}
