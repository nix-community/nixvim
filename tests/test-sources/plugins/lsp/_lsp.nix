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
        };
      };

      assertions =
        let
          enabledServers = builtins.filter (server: server.enable) (builtins.attrValues config.lsp.servers);

          toLua = lib.nixvim.lua.toLua' {
            removeNullAttrValues = true;
            removeEmptyAttrValues = true;
            removeEmptyListEntries = false;
            removeNullListEntries = false;
            multiline = true;
          };

          serverCount = builtins.length enabledServers;
          expectedCount = 2;

          baseServer = builtins.elemAt enabledServers 0;

          nilServer = builtins.elemAt enabledServers 1;
          nilSettings = toLua nilServer.settings.settings;
          expectedNilSettings = toLua {
            nil.formatting.command = [
              "real"
              "example"
            ];
          };
        in
        [
          {
            assertion = serverCount == expectedCount;
            message = "Expected ${toString expectedCount} enabled LSP server!";
          }
          {
            assertion = baseServer.name == "*";
            message = ''
              baseServer's `name` does not match expected value.

              Expected: "*"

              Actual: ${baseServer.name}
            '';
          }
          {
            assertion = nilSettings == expectedNilSettings;
            message = ''
              nil's `extraOptions.settings` does not match expected value.

              Expected: ${expectedNilSettings}

              Actual: ${nilSettings}
            '';
          }
        ];
    };

  package-fallback =
    { config, ... }:
    {
      test.buildNixvim = false;

      plugins.lsp = {
        enable = true;
        servers = {
          nil_ls = {
            enable = true;

            packageFallback = true;
          };
          rust_analyzer = {
            enable = true;

            installCargo = true;
            installRustc = true;

            packageFallback = true;
          };
          hls = {
            enable = true;

            installGhc = true;
            packageFallback = true;
          };
        };
      };

      assertions =
        let
          assertAfter = name: pkg: [
            {
              assertion = lib.all (x: x != pkg) config.extraPackages;
              message = "Expected `${name}` not to be in extraPackages";
            }
            {
              assertion = lib.any (x: x == pkg) config.extraPackagesAfter;
              message = "Expected `${name}` to be in extraPackagesAfter";
            }
          ];
        in
        with config.plugins.lsp.servers;
        (
          assertAfter "nil" nil_ls.package
          ++ assertAfter "rust-analyzer" rust_analyzer.package
          ++ assertAfter "cargo" rust_analyzer.cargoPackage
          ++ assertAfter "rustc" rust_analyzer.rustcPackage
          ++ assertAfter "haskell-language-server" hls.package
          ++ assertAfter "ghc" hls.ghcPackage
        );
    };
}
