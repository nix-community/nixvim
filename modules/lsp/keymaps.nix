{ lib, config, ... }:
let
  inherit (lib) types;
  inherit (lib.nixvim.keymaps) mkMapOptionSubmodule;

  cfg = config.lsp;

  # An extra module to include in the keymap option submodule
  # Declares and implements a specialised `lspBufAction` option
  extraKeymapModule =
    { config, options, ... }:
    {
      options.lspBufAction = lib.mkOption {
        type = types.nullOr types.str;
        description = ''
          LSP buffer action to use for `action`.

          If non-null, the keymap's `action` will be defined as `vim.lsp.buf.<action>`.

          See [`:h lsp-buf`](https://neovim.io/doc/user/lsp.html#lsp-buf)
        '';
        default = null;
        example = "hover";
      };

      config.action = lib.mkIf (config.lspBufAction != null) (
        lib.mkDerivedConfig options.lspBufAction (
          action: lib.nixvim.mkRaw "vim.lsp.buf[${lib.nixvim.toLuaObject action}]"
        )
      );
    };
in
{
  options.lsp = {
    keymaps = lib.mkOption {
      type = types.listOf (mkMapOptionSubmodule {
        action.example = "<CMD>LspRestart<Enter>";
        extraModules = [ extraKeymapModule ];
      });
      description = ''
        Keymaps to register when a language server is attached.
      '';
      default = [ ];
      example = [
        {
          key = "gd";
          lspBufAction = "definition";
        }
        {
          key = "gD";
          lspBufAction = "references";
        }
        {
          key = "gt";
          lspBufAction = "type_definition";
        }
        {
          key = "gi";
          lspBufAction = "implementation";
        }
        {
          key = "K";
          lspBufAction = "hover";
        }

        {
          key = "<leader>k";
          action = lib.nixvim.nestedLiteralLua "function() vim.diagnostic.jump({ count=-1, float=true }) end";
        }
        {
          key = "<leader>j";
          action = lib.nixvim.nestedLiteralLua "function() vim.diagnostic.jump({ count=1, float=true }) end";
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
          key = "gd";
          action = lib.nixvim.nestedLiteralLua "require('telescope.builtin').lsp_definitions";
        }
        {
          key = "K";
          action = "<CMD>Lspsaga hover_doc<Enter>";
        }
      ];
    };
  };

  config = lib.mkIf (cfg.keymaps != [ ]) {
    autoGroups.nixvim_lsp_binds.clear = false;

    autoCmd = [
      {
        event = "LspAttach";
        group = "nixvim_lsp_binds";
        callback = lib.nixvim.mkRaw ''
          function(args)
            local __keymaps = ${
              lib.nixvim.lua.toLua' {
                multiline = true;
                indent = "  ";
              } cfg.keymaps
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
        desc = "Load LSP keymaps";
      }
    ];
  };
}
