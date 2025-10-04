{
  example = {
    lsp.servers = {
      "*".config = {
        enable = true;
        root_markers = [ ".git" ];
        capabilities.textDocument.semanticTokens = {
          multilineTokenSupport = true;
        };
      };
      luals.enable = true;
      clangd = {
        enable = true;
        config = {
          cmd = [
            "clangd"
            "--background-index"
          ];
          root_markers = [
            "compile_commands.json"
            "compile_flags.txt"
          ];
          filetypes = [
            "c"
            "cpp"
          ];
        };
      };
    };
  };

  keymaps =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      autoCmds = config.autoCmd;
      autoCmd = builtins.head autoCmds;

      print = lib.generators.toPretty { };
      expect = name: expected: actual: {
        assertion = expected == actual;
        message = "Expected ${name} to be ${print expected}, but found ${print actual}";
      };
    in
    {
      lsp.keymaps = [
        {
          key = "gd";
          lspBufAction = "definition";
        }
        {
          key = "K";
          lspBufAction = "hover";
        }
        {
          key = "<leader>k";
          action = lib.nixvim.mkRaw "function() vim.diagnostic.jump({ count=-1, float=true }) end";
        }
        {
          key = "<leader>j";
          action = lib.nixvim.mkRaw "function() vim.diagnostic.jump({ count=1, float=true }) end";
        }
        {
          key = "<leader>lx";
          action = "<CMD>LspStop<Enter>";
        }
      ];

      assertions = [
        (expect "number of autocmds" 1 (builtins.length autoCmds))
        (expect "event" "LspAttach" autoCmd.event)
        (expect "group" "nixvim_lsp_binds" autoCmd.group)
      ];

      test.extraInputs = [
        (pkgs.testers.testEqualContents {
          assertion = "lsp keymaps autocmd callback";
          actual = pkgs.writeText "actual.lua" (autoCmd.callback.__raw or "");
          expected = pkgs.writeText "expected.lua" ''
            function(args)
              local __keymaps = {
                {
                  action = vim.lsp.buf["definition"],
                  key = "gd",
                  mode = ""
                },
                {
                  action = vim.lsp.buf["hover"],
                  key = "K",
                  mode = ""
                },
                {
                  action = function() vim.diagnostic.jump({ count=-1, float=true }) end,
                  key = "<leader>k",
                  mode = ""
                },
                {
                  action = function() vim.diagnostic.jump({ count=1, float=true }) end,
                  key = "<leader>j",
                  mode = ""
                },
                {
                  action = "<CMD>LspStop<Enter>",
                  key = "<leader>lx",
                  mode = ""
                }
              }

              for _, keymap in ipairs(__keymaps) do
                local options = vim.tbl_extend(
                  "keep",
                  keymap.options or {},
                  { buffer = args.buf }
                )
                vim.keymap.set(keymap.mode, keymap.key, keymap.action, options)
              end
            end
          '';
        })
      ];

      # Test that keymaps are registered after LspAttach
      extraConfigLuaPost = ''
        -- Assert keymaps not registered
        local keymaps_pre_attach = vim.api.nvim_buf_get_keymap(0, "")
        if not vim.tbl_isempty(keymaps_pre_attach) then
          print("Unexpected keymaps registered before LspAttach:")
          vim.print(keymaps_pre_attach)
        end

        -- Trigger the LspAttach autocmd
        vim.api.nvim_exec_autocmds("LspAttach", {
          group = "nixvim_lsp_binds",
          buffer = 0,
          modeline = false,
          data = {
            client_id = "stub_id",
          },
        })

        -- Assert keymaps are registered
        local keymaps_post_attach = vim.api.nvim_buf_get_keymap(0, "")

        local keymaps_post_attach_len = vim.tbl_count(keymaps_post_attach)
        if keymaps_post_attach_len ~= 5 then
          print("Expected 5 keymaps to be registered after LspAttach, but found", keymaps_post_attach_len)
          vim.print(keymaps_post_attach)
        end

        for _, expected in
          ipairs({
            "gd",
            "K",
            "\\k",
            "\\j",
            "\\lx",
          })
        do
          local has_keymap = vim.tbl_contains(
            keymaps_post_attach,
            function(keymap) return keymap.lhsraw == expected end,
            { predicate = true }
          )
          if not has_keymap then
            print("keymap", expected, "was not registered")
          end
        end
      '';
    };

  package-fallback =
    { lib, config, ... }:
    {
      test.buildNixvim = false;

      lsp = {
        servers = {
          nil_ls.enable = true;
          rust_analyzer = {
            enable = true;
            packageFallback = true;
          };
          hls = {
            enable = true;
            packageFallback = true;
          };
        };
      };

      assertions =
        let
          assertPrefix = name: pkg: [
            {
              assertion = lib.all (x: x == pkg) config.extraPackages;
              message = "Expected `${name}` to be in extraPackages";
            }
            {
              assertion = lib.any (x: x != pkg) config.extraPackagesAfter;
              message = "Expected `${name}` not to be in extraPackagesAfter";
            }
          ];
          assertSuffix = name: pkg: [
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
        with config.lsp.servers;
        (
          assertPrefix "nil" nil_ls.package
          ++ assertSuffix "rust-analyzer" rust_analyzer.package
          ++ assertSuffix "haskell-language-server" hls.package
        );
    };
}
