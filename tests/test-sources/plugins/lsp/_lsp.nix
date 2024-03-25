{pkgs, ...}: {
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
          "<leader>j" = {
            action = "goto_next";
            desc = "Go to next diagnostic";
          };
        };

        lspBuf = {
          "gd" = "definition";
          "gD" = "references";
          "gt" = "type_definition";
          "gi" = "implementation";
          "K" = {
            action = "hover";
            desc = "Hover";
          };
        };

        extra = [
          {
            key = "<leader>li";
            action = "<CMD>LspInfo<Enter>";
          }
          {
            key = "<leader>lx";
            action = "<CMD>LspStop<Enter>";
          }
          {
            key = "<leader>ls";
            action = "<CMD>LspStart<Enter>";
          }
          {
            key = "<leader>lr";
            action = "<CMD>LspRestart<Enter>";
          }
          {
            key = "<leader>ll";
            action = "<CMD>LspLog<Enter>";
          }
        ];
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
          package = null;
        };
        nil_ls.enable = true;
        rust-analyzer = {
          enable = true;
          installCargo = true;
          installRustc = true;
        };
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

  all-servers =
    pkgs.lib.optionalAttrs
    # This fails on darwin
    # See https://github.com/NixOS/nix/issues/4119
    (!pkgs.stdenv.isDarwin)
    {
      plugins.lsp = {
        enable = true;

        servers = {
          ansiblels.enable = true;
          astro.enable = true;
          bashls.enable = true;
          beancount.enable = true;
          biome.enable = true;
          ccls.enable = true;
          clangd.enable = true;
          clojure-lsp.enable = true;
          cmake.enable = true;
          csharp-ls.enable = true;
          cssls.enable = true;
          dagger.enable = true;
          dartls.enable = true;
          denols.enable = true;
          dhall-lsp-server.enable = true;
          digestif.enable = true;
          dockerls.enable = true;
          efm.enable = true;
          elmls.enable = true;
          emmet_ls.enable = true;
          eslint.enable = true;
          elixirls.enable = true;
          fortls.enable = true;
          # pkgs.fsautocomplete only supports linux platforms
          fsautocomplete.enable = pkgs.stdenv.isLinux;
          futhark-lsp.enable = true;
          gleam.enable = true;
          gopls.enable = true;
          golangci-lint-ls.enable = true;
          graphql.enable = true;
          helm-ls.enable = true;
          hls.enable = true;
          html.enable = true;
          htmx.enable = true;
          java-language-server.enable = true;
          jsonls.enable = true;
          julials.enable = true;
          kotlin-language-server.enable = true;
          leanls.enable = true;
          lemminx.enable = true;
          ltex.enable = true;
          lua-ls.enable = true;
          marksman.enable = true;
          metals.enable = true;
          nil_ls.enable = true;
          nixd.enable = true;
          nushell.enable = true;
          ocamllsp.enable = true;
          ols.enable =
            # ols is not supported on aarch64-linux
            (pkgs.stdenv.hostPlatform.system != "aarch64-linux")
            # As of 2024-01-04, ols is broken on darwin
            # TODO: re-enable this test when fixed
            && !pkgs.stdenv.isDarwin;
          # As of 2024-03-05, omnisharp-roslyn is broken on darwin
          # TODO: re-enable this test when fixed
          omnisharp.enable = !pkgs.stdenv.isDarwin;
          perlpls.enable = true;
          pest_ls.enable = true;
          prismals.enable = true;
          prolog-ls.enable = true;
          purescriptls.enable = true;
          pylsp.enable = true;
          # As of 2024-03-11, pylyzer is broken
          # TODO: re-enable this test when fixed
          # https://github.com/mtshiba/pylyzer/issues/78
          pylyzer.enable = false;
          pyright.enable = true;
          ruff-lsp.enable = true;
          rust-analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };
          slint-lsp.enable = true;
          solargraph.enable = true;
          # As of 2024-03-11, sourcekit-lsp is broken on aarch64
          # TODO: re-enable this test when fixed
          sourcekit.enable = !pkgs.stdenv.isAarch64;
          sqls.enable = true;
          svelte.enable = true;
          tailwindcss.enable = true;
          taplo.enable = true;
          templ.enable = true;
          terraformls.enable = true;
          texlab.enable = true;
          tsserver.enable = true;
          typos-lsp.enable = true;
          typst-lsp.enable = true;
          vala-ls.enable = true;
          vls.enable = true;
          vuels.enable = true;
          yamlls.enable = true;
          zls.enable = true;
        };
      };
    };
}
