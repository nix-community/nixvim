{ lib, ... }:
{
  empty = {
    plugins.lsp.enable = true;
  };

  example = {
    plugins.lsp = {
      enable = true;
      inlayHints = true;

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
        nil-ls.enable = true;
        rust-analyzer = {
          enable = true;
          installCargo = true;
          installRustc = true;
        };
        ruff-lsp = {
          enable = true;
          extraOptions = {
            init_options.settings.args = [ "--config=/path/to/config.toml" ];
          };
        };
        pylsp = {
          enable = true;
          filetypes = [ "python" ];
          autostart = false;
        };
        # rootDir
        tinymist = {
          enable = true;
          rootDir = ''
            require 'lspconfig.util'.root_pattern('.git', 'main.typ')
          '';
        };
      };
    };
  };

  volar-tsls-integration =
    { config, ... }:
    {
      plugins.lsp = {
        enable = true;
        servers = {
          volar.enable = true;
          ts-ls = {
            enable = true;
            filetypes = [ "typescript" ];
          };
        };
      };

      assertions = [
        {
          assertion = lib.any (x: x == "vue") config.plugins.lsp.servers.ts-ls.filetypes;
          message = "Expected `vue` filetype configuration.";
        }
        {
          assertion = lib.any (
            x: x.name == "@vue/typescript-plugin"
          ) config.plugins.lsp.servers.ts-ls.extraOptions.init_options.plugins;
          message = "Expected `@vue/typescript-plugin` plugin.";
        }
        {
          assertion = lib.any (x: x == "typescript") config.plugins.lsp.servers.ts-ls.filetypes;
          message = "Expected `typescript` filetype configuration.";
        }
      ];
    };

  tsls-filetypes =
    { config, ... }:
    {
      plugins.lsp = {
        enable = true;
        servers = {
          ts-ls = {
            enable = true;
          };
        };
      };

      assertions = [
        {
          assertion = lib.all (x: x != "vue") config.plugins.lsp.servers.ts-ls.filetypes;
          message = "Did not expect `vue` filetype configuration.";
        }
        (lib.mkIf (config.plugins.lsp.servers.ts-ls.extraOptions ? init_options) {
          assertion = lib.all (
            x: x.name != "@vue/typescript-plugin"
          ) config.plugins.lsp.servers.ts-ls.extraOptions.init_options.plugins;
          message = "Did not expect `@vue/typescript-plugin` plugin.";
        })
        {
          assertion = lib.any (x: x == "typescript") config.plugins.lsp.servers.ts-ls.filetypes;
          message = "Expected `typescript` filetype configuration.";
        }
      ];
    };
}
