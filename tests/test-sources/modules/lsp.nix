{ pkgs }:
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

  feature-toggles-defaults =
    { config, lib, ... }:
    {
      assertions = [
        {
          assertion = config.lsp.inlayHints.enable == false;
          message = "Expected lsp.inlayHints.enable to default to false.";
        }
        {
          assertion = config.lsp.codelens.enable == false;
          message = "Expected lsp.codelens.enable to default to false.";
        }
        {
          assertion = config.lsp.completion.enable == false;
          message = "Expected lsp.completion.enable to default to false.";
        }
        {
          assertion = config.lsp.completion.settings == { };
          message = "Expected lsp.completion.settings to default to an empty attrs.";
        }
        {
          assertion = config.lsp.semanticTokens.enable == null;
          message = "Expected lsp.semanticTokens.enable to default to null.";
        }
        {
          assertion = config.lsp.documentColor.enable == null;
          message = "Expected lsp.documentColor.enable to default to null.";
        }
        {
          assertion = config.lsp.documentColor.settings == { };
          message = "Expected lsp.documentColor.settings to default to an empty attrs.";
        }
        {
          assertion = config.lsp.linkedEditingRange.enable == false;
          message = "Expected lsp.linkedEditingRange.enable to default to false.";
        }
        {
          assertion = config.lsp.onTypeFormatting.enable == false;
          message = "Expected lsp.onTypeFormatting.enable to default to false.";
        }
        {
          assertion = config.lsp.inlineCompletion.enable == false;
          message = "Expected lsp.inlineCompletion.enable to default to false.";
        }
        {
          assertion = config.lsp.luaConfig.content == "";
          message = "Expected LSP feature toggles to emit no global Lua by default.";
        }
        {
          assertion = !lib.hasInfix "__nixvim_lsp_on_attach" config.extraConfigLua;
          message = "Expected no LSP on-attach handler by default.";
        }
      ];
    };

  feature-toggles-example =
    { config, lib, ... }:
    let
      attachLua = config.extraConfigLua;
      globalLua = config.lsp.luaConfig.content;
    in
    {
      lsp = {
        onAttach = "local __nixvim_on_attach_order_probe = true";
        inlayHints.enable = true;
        codelens.enable = true;
        completion = {
          enable = true;
          settings.autotrigger = true;
        };
        semanticTokens.enable = true;
        documentColor = {
          enable = true;
          settings.style = "virtual";
        };
        linkedEditingRange.enable = true;
        onTypeFormatting.enable = true;
        inlineCompletion.enable = true;
      };

      assertions = [
        {
          assertion = lib.hasInfix "vim.lsp.inlay_hint.enable(true)" globalLua;
          message = "Expected inlay hint Lua when enabled.";
        }
        {
          assertion = lib.hasInfix "vim.lsp.codelens.enable(true)" globalLua;
          message = "Expected codelens Lua when enabled.";
        }
        {
          assertion = lib.hasInfix "vim.lsp.semantic_tokens.enable(true)" globalLua;
          message = "Expected semantic token Lua when enabled.";
        }
        {
          assertion = lib.hasInfix ''vim.lsp.document_color.enable(true, nil, { style = "virtual" })'' globalLua;
          message = "Expected document color Lua with settings when enabled.";
        }
        {
          assertion = lib.hasInfix "vim.lsp.linked_editing_range.enable(true)" globalLua;
          message = "Expected linked editing range Lua when enabled.";
        }
        {
          assertion = lib.hasInfix "vim.lsp.on_type_formatting.enable(true)" globalLua;
          message = "Expected on-type formatting Lua when enabled.";
        }
        {
          assertion = lib.hasInfix "vim.lsp.inline_completion.enable(true)" globalLua;
          message = "Expected inline completion Lua when enabled.";
        }
        {
          assertion = lib.hasInfix "client:supports_method('textDocument/completion', bufnr)" attachLua;
          message = "Expected the completion capability check in the LspAttach callback.";
        }
        {
          assertion = lib.hasInfix "vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })" attachLua;
          message = "Expected completion Lua with settings in the LspAttach callback.";
        }
        {
          # `enable` snapshots `triggerCharacters`, so `onAttach` must run first.
          assertion =
            let
              beforeEnable = builtins.head (lib.splitString "vim.lsp.completion.enable" attachLua);
            in
            lib.hasInfix "__nixvim_on_attach_order_probe" beforeEnable;
          message = "Expected `onAttach` to run before the completion enable call.";
        }
      ];
    };

  feature-toggles-disabled =
    { config, lib, ... }:
    let
      globalLua = config.lsp.luaConfig.content;
    in
    {
      lsp = {
        semanticTokens.enable = false;
        documentColor.enable = false;
      };

      assertions = [
        {
          assertion = lib.hasInfix "vim.lsp.semantic_tokens.enable(false)" globalLua;
          message = "Expected semantic token Lua when disabled explicitly.";
        }
        {
          assertion = lib.hasInfix "vim.lsp.document_color.enable(false)" globalLua;
          message = "Expected document color Lua when disabled explicitly.";
        }
      ];
    };

  document-color-settings-need-explicit-enable =
    { config, lib, ... }:
    let
      globalLua = config.lsp.luaConfig.content;
    in
    {
      lsp.documentColor.settings.style = "virtual";

      assertions = [
        {
          assertion = !lib.hasInfix "vim.lsp.document_color" globalLua;
          message = "Expected no document color Lua until `enable` is set.";
        }
      ];
    };

  # Neovim stores `opts` before applying `enable`, so settings survive an
  # explicit disable for a later manual enable.
  document-color-disabled-keeps-settings =
    { config, lib, ... }:
    let
      globalLua = config.lsp.luaConfig.content;
    in
    {
      lsp.documentColor = {
        enable = false;
        settings.style = "virtual";
      };

      assertions = [
        {
          assertion = lib.hasInfix ''vim.lsp.document_color.enable(false, nil, { style = "virtual" })'' globalLua;
          message = "Expected document color settings to be kept when disabled.";
        }
      ];
    };

  document-color-enabled-no-settings =
    { config, lib, ... }:
    let
      globalLua = config.lsp.luaConfig.content;
    in
    {
      lsp.documentColor.enable = true;

      assertions = [
        {
          assertion = lib.hasInfix "vim.lsp.document_color.enable(true)" globalLua;
          message = "Expected a bare enable call when document color has no settings.";
        }
      ];
    };

  completion-empty =
    { config, lib, ... }:
    {
      lsp.completion.enable = true;

      assertions = [
        {
          assertion = lib.hasInfix "vim.lsp.completion.enable(true, client.id, bufnr, { })" config.extraConfigLua;
          message = "Expected completion Lua with an empty opts table when no settings are defined.";
        }
      ];
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

  on-attach-dynamic-registration = {
    lsp.onAttach = ''
      table.insert(_G.__nixvim_lsp_on_attach_calls, {
        client = client.id,
        bufnr = bufnr,
        event_buf = event.buf,
        event_client = event.data.client_id,
      })
    '';

    extraConfigLuaPre = ''
      _G.__nixvim_lsp_on_attach_calls = {}
      vim.lsp.handlers["client/registerCapability"] = function()
        return "registered"
      end
    '';

    extraConfigLuaPost = ''
      local get_client_by_id = vim.lsp.get_client_by_id
      vim.lsp.get_client_by_id = function(client_id)
        if client_id == "stub_id" then
          return {
            id = "stub_id",
            attached_buffers = {
              [1] = true,
            },
          }
        end
      end

      local attach_buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_exec_autocmds("LspAttach", {
        group = "nixvim_lsp_on_attach",
        buffer = attach_buf,
        modeline = false,
        data = {
          client_id = "stub_id",
        },
      })

      local result = vim.lsp.handlers["client/registerCapability"](nil, nil, { client_id = "stub_id" })
      vim.lsp.get_client_by_id = get_client_by_id

      if result ~= "registered" then
        print("Expected client/registerCapability handler to return original result, got", result)
      end

      local expected_calls = {
        { client = "stub_id", bufnr = attach_buf, event_buf = attach_buf, event_client = "stub_id" },
        { client = "stub_id", bufnr = 1, event_buf = 1, event_client = "stub_id" },
      }

      for index, expected in ipairs(expected_calls) do
        local actual = _G.__nixvim_lsp_on_attach_calls[index]
        if actual == nil then
          print("Missing lsp.onAttach call", index)
        elseif actual.client ~= expected.client
          or actual.bufnr ~= expected.bufnr
          or actual.event_buf ~= expected.event_buf
          or actual.event_client ~= expected.event_client
        then
          print(
            "Unexpected lsp.onAttach call",
            index,
            "expected",
            vim.inspect(expected),
            "got",
            vim.inspect(actual)
          )
        end
      end

      if #_G.__nixvim_lsp_on_attach_calls ~= #expected_calls then
        print(
          "Expected",
          #expected_calls,
          "lsp.onAttach calls, got",
          #_G.__nixvim_lsp_on_attach_calls
        )
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
              assertion = lib.elem pkg config.extraPackages;
              message = "Expected `${name}` to be in extraPackages";
            }
            {
              assertion = !(lib.elem pkg config.extraPackagesAfter);
              message = "Expected `${name}` not to be in extraPackagesAfter";
            }
          ];
          assertSuffix = name: pkg: [
            {
              assertion = !(lib.elem pkg config.extraPackages);
              message = "Expected `${name}` not to be in extraPackages";
            }
            {
              assertion = lib.elem pkg config.extraPackagesAfter;
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

  # Assert that we don't have any redundant custom modules
  custom-server-modules =
    { lib, options, ... }:
    let
      rootPrefix = toString ../../../. + "/";
      customDir = ../../../modules/lsp/servers/custom;
      serverOptions = (opt: opt.type.getSubOptions opt.loc) options.lsp.servers;
      modules = lib.pipe customDir [
        builtins.readDir
        (lib.filterAttrs (name: _: !(serverOptions ? ${lib.strings.removeSuffix ".nix" name})))
        (lib.mapAttrsToList (
          name: type: customDir + "/${name}" + lib.optionalString (type == "directory") "/default.nix"
        ))
        (builtins.filter (lib.strings.hasSuffix ".nix"))
        (builtins.filter lib.pathExists)
        (map (module: lib.strings.removePrefix rootPrefix (toString module)))
      ];
    in
    {
      test.buildNixvim = false;

      assertions = [
        {
          assertion = modules == [ ];
          message = ''
            The following custom modules do not correspond to an LSP server option:${
              lib.concatMapStrings (module: "\n- ${module}") modules
            }
          '';
        }
      ];
    };

  # Regression test for mkServerOption:
  # Ensures tryEval catches missing packages when evaluating the description.
  # See https://github.com/nix-community/nixvim/issues/4033
  missing-package =
    { lib, options, ... }:
    let
      # `lsp.servers.lua_ls` option
      serverOpt = lib.pipe options.lsp.servers [
        (opt: opt.type.getSubOptions opt.loc)
        (opts: opts.lua_ls)
      ];

      # `lsp.servers.lua_ls.package` option
      packageOpt = (serverOpt.type.getSubOptions serverOpt.loc).package;

      # The lua_ls package attr to remove from pkgs
      packageName = lib.pipe ../../../modules/lsp/servers/packages.nix [
        import
        (lib.getAttr "packages")
        (lib.getAttr "lua_ls")
        lib.toList
        lib.head
      ];
    in
    {
      # Remove lua_ls's package
      _module.args.pkgs = lib.mkOverride 0 (lib.removeAttrs pkgs [ packageName ]);

      assertions = [
        {
          # Expect the lua_ls description to evaluate without a link
          assertion = serverOpt.description == "The lua_ls language server.\n";
          message = ''
            Wrong description for `${serverOpt}`. Found:
            ${serverOpt.description}
          '';
        }
        {
          # Expect the package default to throw
          assertion = !(builtins.tryEval packageOpt.default).success;
          message = "Expected `${packageOpt}`'s default to throw.";
        }
      ];

      test.buildNixvim = false;
    };
}
