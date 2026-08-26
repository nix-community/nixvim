{
  lib,
  config,
  options,
  ...
}:
let
  cfg = config.lsp;
  opts = options.lsp;
in
{
  options.lsp = {
    luaConfig = lib.mkOption {
      type = lib.types.pluginLuaConfig;
      default = { };
      description = ''
        Lua code configuring LSP.
      '';
    };

    inlayHints = {
      enable = lib.mkEnableOption null // {
        description = ''
          Whether to enable inlay hints globally.

          See [`:h lsp-inlay_hint`](https://neovim.io/doc/user/lsp/#lsp-inlay_hint)
        '';
      };
    };
    codelens = {
      enable = lib.mkEnableOption null // {
        description = ''
          Whether to enable codelens globally.

          See [`:h lsp-codelens`](https://neovim.io/doc/user/lsp/#lsp-codelens)
        '';
      };
    };
    # Completion is enabled per buffer in `on-attach.nix`; the others are global.
    completion = {
      enable = lib.mkEnableOption null // {
        description = ''
          Whether to enable LSP completion for each attached client that
          supports `textDocument/completion`.

          See [`:h lsp-completion`](https://neovim.io/doc/user/lsp/#lsp-completion)
        '';
      };
      settings = lib.nixvim.mkSettingsOption {
        description = ''
          Options passed to `vim.lsp.completion.enable()`, such as `autotrigger`.

          See [`:h lsp-completion`](https://neovim.io/doc/user/lsp/#lsp-completion)
        '';
        example = {
          autotrigger = true;
        };
      };
    };
    semanticTokens = {
      enable = lib.mkOption {
        type = lib.types.nullOr lib.types.bool;
        default = null;
        description = ''
          Whether to enable semantic tokens globally.

          Neovim enables semantic tokens by default. Use `null` to keep that
          default, or `false` to turn them off.

          See [`:h lsp-semantic_tokens`](https://neovim.io/doc/user/lsp/#lsp-semantic_tokens)
        '';
      };
    };
    documentColor = {
      enable = lib.mkOption {
        type = lib.types.nullOr lib.types.bool;
        default = null;
        description = ''
          Whether to enable document color highlighting globally.

          Neovim enables document color highlighting by default. Use `null` to
          keep that default, or `false` to turn it off. `${opts.documentColor.settings}`
          only applies when this is set.

          Requires Neovim 0.12 or later.

          See [`:h lsp-document_color`](https://neovim.io/doc/user/lsp/#lsp-document_color)
        '';
      };
      settings = lib.nixvim.mkSettingsOption {
        description = ''
          Options passed to `vim.lsp.document_color.enable()`, such as `style`.

          > [!important]
          > Neovim enables document color highlighting by default, but nixvim
          > only applies these settings when `${opts.documentColor.enable}` is
          > set explicitly.

          See [`:h lsp-document_color`](https://neovim.io/doc/user/lsp/#lsp-document_color)
        '';
        example = {
          style = "virtual";
        };
      };
    };
    linkedEditingRange = {
      enable = lib.mkEnableOption null // {
        description = ''
          Whether to enable linked editing ranges globally.

          Requires Neovim 0.12 or later.

          See [`:h lsp-linked_editing_range`](https://neovim.io/doc/user/lsp/#lsp-linked_editing_range)
        '';
      };
    };
    onTypeFormatting = {
      enable = lib.mkEnableOption null // {
        description = ''
          Whether to enable on-type formatting globally.

          Requires Neovim 0.12 or later.

          See [`:h lsp-on_type_formatting`](https://neovim.io/doc/user/lsp/#lsp-on_type_formatting)
        '';
      };
    };
    inlineCompletion = {
      enable = lib.mkEnableOption null // {
        description = ''
          Whether to enable inline completion globally.

          Requires Neovim 0.12 or later.

          See [`:h lsp-inline_completion`](https://neovim.io/doc/user/lsp/#lsp-inline_completion)
        '';
      };
    };
  };

  imports = [
    ./servers
    ./keymaps.nix
    ./on-attach.nix
  ];

  config = {
    lsp.luaConfig.content = lib.mkMerge [
      (lib.mkIf cfg.inlayHints.enable "vim.lsp.inlay_hint.enable(true)")
      (lib.mkIf cfg.codelens.enable "vim.lsp.codelens.enable(true)")
      (lib.mkIf (
        cfg.semanticTokens.enable != null
      ) "vim.lsp.semantic_tokens.enable(${lib.boolToString cfg.semanticTokens.enable})")
      (
        let
          inherit (cfg.documentColor) settings;
          # `opts` is the third argument, so pass `nil` for `filter`. Neovim
          # stores `opts` before applying `enable`, so settings survive an
          # explicit disable and apply on a later manual enable.
          opts = lib.optionalString (settings != { }) ", nil, ${lib.nixvim.toLuaObject settings}";
        in
        lib.mkIf (
          cfg.documentColor.enable != null
        ) "vim.lsp.document_color.enable(${lib.boolToString cfg.documentColor.enable}${opts})"
      )
      (lib.mkIf cfg.linkedEditingRange.enable "vim.lsp.linked_editing_range.enable(true)")
      (lib.mkIf cfg.onTypeFormatting.enable "vim.lsp.on_type_formatting.enable(true)")
      (lib.mkIf cfg.inlineCompletion.enable "vim.lsp.inline_completion.enable(true)")
    ];

    extraConfigLua = lib.mkIf (cfg.luaConfig.content != "") ''
      -- LSP {{{
      do
        ${cfg.luaConfig.content}
      end
      -- }}}
    '';
  };
}
