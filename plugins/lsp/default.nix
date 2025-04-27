{ lib, ... }:
let
  inherit (lib) mkOption types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "lsp";
  packPathName = "nvim-lspconfig";
  package = "nvim-lspconfig";

  callSetup = false;
  hasSettings = false;

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  imports = [ ./language-servers ];

  extraOptions = {
    keymaps = {
      silent = mkOption {
        type = types.bool;
        description = "Whether nvim-lsp keymaps should be silent";
        default = false;
      };

      diagnostic = mkOption {
        type = with types; attrsOf (either str (attrsOf anything));
        description = "Mappings for `vim.diagnostic.<action>` functions to be added when an LSP is attached.";
        example = {
          "<leader>k" = "goto_prev";
          "<leader>j" = "goto_next";
        };
        default = { };
      };

      lspBuf = mkOption {
        type = with types; attrsOf (either str (attrsOf anything));
        description = "Mappings for `vim.lsp.buf.<action>` functions to be added when an LSP it attached.";
        example = {
          "gd" = "definition";
          "gD" = "references";
          "gt" = "type_definition";
          "gi" = "implementation";
          "K" = "hover";
        };
        default = { };
      };

      extra = mkOption {
        type = types.listOf lib.nixvim.keymaps.deprecatedMapOptionSubmodule;
        apply = map lib.nixvim.keymaps.removeDeprecatedMapAttrs;
        description = ''
          Extra keymaps to register when an LSP is attached.
          This can be used to customise LSP behaviour, for example with "telescope" or the "Lspsaga" plugin, as seen in the examples.
        '';
        example = [
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
            action.__raw = "require('telescope.builtin').lsp_definitions";
          }
          {
            key = "K";
            action = "<CMD>Lspsaga hover_doc<Enter>";
          }
        ];
        default = [ ];
      };
    };

    enabledServers = mkOption {
      type =
        with types;
        listOf (submodule {
          options = {
            name = mkOption {
              type = str;
              description = "The server's name";
            };

            extraOptions = mkOption {
              type = attrsOf anything;
              description = "Extra options for the server";
            };
          };
        });
      description = "A list of enabled LSP servers. Don't use this directly.";
      default = [ ];
      internal = true;
      visible = false;
    };

    inlayHints = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable LSP inlay-hints globally.

        See [`:h lsp-inlay_hint`](https://neovim.io/doc/user/lsp.html#lsp-inlay_hint).
      '';
    };

    onAttach = mkOption {
      type = types.lines;
      description = "A lua function to be run when a new LSP buffer is attached. The argument `client` and `bufnr` is provided.";
      default = "";
    };

    capabilities = mkOption {
      type = types.lines;
      description = "Lua code that modifies inplace the `capabilities` table.";
      default = "";
    };

    setupWrappers = mkOption {
      type = with types; listOf (functionTo str);
      description = "Code to be run to wrap the setup args. Takes in an argument containing the previous results, and returns a new string of code.";
      default = [ ];
    };

    preConfig = mkOption {
      type = types.lines;
      description = "Code to be run before loading the LSP. Useful for requiring plugins";
      default = "";
    };

    postConfig = mkOption {
      type = types.lines;
      description = "Code to be run after loading the LSP. This is an internal option";
      default = "";
    };
  };

  extraConfig = cfg: {
    keymapsOnEvents.LspAttach =
      let
        mkMaps =
          prefix: descPrefix:
          lib.mapAttrsToList (
            key: action:
            let
              actionStr = action.action or action;
              mode = action.mode or "n";
              actionProps = lib.optionalAttrs (builtins.isAttrs action) (
                builtins.removeAttrs action [
                  "action"
                  "mode"
                ]
              );
            in
            {
              inherit key mode;
              action = lib.nixvim.mkRaw (prefix + actionStr);

              options = {
                inherit (cfg.keymaps) silent;
                desc = "${descPrefix} ${actionStr}";
              } // actionProps;
            }
          );
      in
      mkMaps "vim.diagnostic." "Lsp diagnostic" cfg.keymaps.diagnostic
      ++ mkMaps "vim.lsp.buf." "Lsp buf" cfg.keymaps.lspBuf
      ++ cfg.keymaps.extra;

    plugins.lsp.luaConfig.content =
      let
        runWrappers =
          wrappers: s:
          if wrappers == [ ] then s else (builtins.head wrappers) (runWrappers (builtins.tail wrappers) s);
      in
      ''
        -- LSP {{{
        do
          ${cfg.preConfig}

          -- inlay hint
          ${lib.optionalString cfg.inlayHints "vim.lsp.inlay_hint.enable(true)"}

          local __lspServers = ${lib.nixvim.toLuaObject cfg.enabledServers}
          -- Adding lspOnAttach function to nixvim module lua table so other plugins can hook into it.
          _M.lspOnAttach = function(client, bufnr)
            ${cfg.onAttach}
          end
          local __lspCapabilities = function()
            capabilities = vim.lsp.protocol.make_client_capabilities()

            ${cfg.capabilities}

            return capabilities
          end

          local __setup = ${runWrappers cfg.setupWrappers "{
            on_attach = _M.lspOnAttach,
            capabilities = __lspCapabilities(),
          }"}

          for i, server in ipairs(__lspServers) do
            local options = ${runWrappers cfg.setupWrappers "server.extraOptions"}

            if options == nil then
              options = __setup
            else
              options = vim.tbl_extend("keep", options, __setup)
            end

            require("lspconfig")[server.name].setup(options)
          end

          ${cfg.postConfig}
        end
        -- }}}
      '';
  };
}
