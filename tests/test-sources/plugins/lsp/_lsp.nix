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
        nil_ls.enable = true;
        rust_analyzer = {
          enable = true;
          installCargo = true;
          installRustc = true;
        };
        ruff = {
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
        # rootMarkers
        tinymist = {
          enable = true;
          rootMarkers = [
            ".git"
            "main.typ"
          ];
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
          ts_ls = {
            enable = true;
            filetypes = [ "typescript" ];
          };
        };
      };

      assertions = [
        {
          assertion = lib.any (x: x == "vue") config.plugins.lsp.servers.ts_ls.filetypes;
          message = "Expected `vue` filetype configuration.";
        }
        {
          assertion = lib.any (
            x: x.name == "@vue/typescript-plugin"
          ) config.plugins.lsp.servers.ts_ls.extraOptions.init_options.plugins;
          message = "Expected `@vue/typescript-plugin` plugin.";
        }
        {
          assertion = lib.any (x: x == "typescript") config.plugins.lsp.servers.ts_ls.filetypes;
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
          ts_ls = {
            enable = true;
          };
        };
      };

      assertions = [
        {
          assertion = lib.all (x: x != "vue") config.plugins.lsp.servers.ts_ls.filetypes;
          message = "Did not expect `vue` filetype configuration.";
        }
        (lib.mkIf (config.plugins.lsp.servers.ts_ls.extraOptions ? init_options) {
          assertion = lib.all (
            x: x.name != "@vue/typescript-plugin"
          ) config.plugins.lsp.servers.ts_ls.extraOptions.init_options.plugins;
          message = "Did not expect `@vue/typescript-plugin` plugin.";
        })
        {
          assertion = lib.any (x: x == "typescript") config.plugins.lsp.servers.ts_ls.filetypes;
          message = "Expected `typescript` filetype configuration.";
        }
      ];
    };

  settings-merge =
    { config, lib, ... }:
    {
      test.runNvim = false;

      plugins = {
        lsp = {
          enable = true;
          servers.nil_ls = {
            enable = true;
            settings.formatting.command = lib.mkForce [
              "real"
              "example"
            ];
          };
          enabledServers = lib.mkAfter [
            {
              name = "second";
              extraOptions.settings = lib.mkIf false {
                should.be = "missing";
              };
            }
            {
              name = "third";
              extraOptions.settings = lib.mkIf true {
                should.be = "present";
              };
            }
          ];
        };
      };

      assertions =
        let
          toLua = lib.nixvim.lua.toLua' {
            removeNullAttrValues = true;
            removeEmptyAttrValues = true;
            removeEmptyListEntries = false;
            removeNullListEntries = false;
            multiline = true;
          };

          print = lib.generators.toPretty {
            multiline = true;
          };

          serverCount = builtins.length config.plugins.lsp.enabledServers;
          expectedCount = 3;

          nilServer = builtins.head config.plugins.lsp.enabledServers;
          nilSettings = toLua nilServer.extraOptions.settings;
          expectedNilSettings = toLua {
            nil.formatting.command = [
              "real"
              "example"
            ];
          };

          secondServer = builtins.elemAt config.plugins.lsp.enabledServers 1;
          expectedSecondServer = {
            name = "second";
            capabilities = null;
            extraOptions = { };
          };

          thirdServer = builtins.elemAt config.plugins.lsp.enabledServers 2;
          expectedThirdServer = {
            name = "third";
            capabilities = null;
            extraOptions.settings.should.be = "present";
          };
        in
        [
          {
            assertion = serverCount == expectedCount;
            message = "Expected ${toString expectedCount} enabled LSP server!";
          }
          {
            assertion = nilSettings == expectedNilSettings;
            message = ''
              nil's `extraOptions.settings` does not match expected value.

              Expected: ${expectedNilSettings}

              Actual: ${nilSettings}
            '';
          }
          {
            assertion = secondServer == expectedSecondServer;
            message = ''
              `secondServer` does not match expected value.

              Expected: ${print expectedSecondServer}

              Actual: ${print secondServer}
            '';
          }
          {
            assertion = secondServer == expectedSecondServer;
            message = ''
              `thirdServer` does not match expected value.

              Expected: ${print expectedThirdServer}

              Actual: ${print thirdServer}
            '';
          }
        ];
    };
}
