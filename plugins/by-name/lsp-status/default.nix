{
  lib,
  config,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "lsp-status";
  originalName = "lsp-status.nvim";
  package = "lsp-status-nvim";
  maintainers = [ lib.maintainers.b3nb5n ];

  settingsOptions =
    let
      mkIndicatorOption =
        default:
        defaultNullOpts.mkStr default ''
          The string to show as diagnostics.
          If you don't have Nerd/Awesome Fonts you can replace defaults with ASCII chars.
        '';
    in
    {
      kind_labels = defaultNullOpts.mkAttrsOf types.str { } ''
        An optional map from LSP symbol kinds to label symbols. Used to decorate the current function name.
      '';

      select_symbol = defaultNullOpts.mkStr "" ''
        An optional handler of the form `function(cursor_pos, document_symbol)` that should return
        `true` if `document_symbol` (a `DocumentSymbol`) should be accepted as the symbol currently
        containing the cursor.
      '';

      current_function = defaultNullOpts.mkBool true ''
        True if the current function should be updated and displayed in the default statusline component.
      '';

      show_filename = defaultNullOpts.mkBool true ''
        True if the current function should be updated and displayed in the default statusline component.
      '';

      indicator_ok = mkIndicatorOption "";
      indicator_errors = mkIndicatorOption "";
      indicator_warnings = mkIndicatorOption "";
      indicator_info = mkIndicatorOption "🛈";
      indicator_hint = mkIndicatorOption "❗";

      indicator_separator = defaultNullOpts.mkStr " " ''
        A string which goes between each diagnostic group symbol and its count.
      '';

      component_separator = defaultNullOpts.mkStr " " ''
        A string which goes between each "chunk" of the statusline component (i.e. different diagnostic groups, messages).
      '';

      diagnostics = defaultNullOpts.mkBool true ''
        If false, the default statusline component does not display LSP diagnostics.
      '';
    };

  callSetup = false;
  extraConfig = cfg: {
    assertions = [
      {
        assertion = config.plugins.lsp.enable;
        message = ''
          Nixvim (plugins.lsp-status): `plugins.lsp` must be enabled to use lsp-status
        '';
      }
    ];

    plugins.lsp = {
      preConfig = ''
        do
          local lsp_status = require('lsp-status')
          lsp_status.config(${lib.nixvim.toLuaObject cfg.settings})
          lsp_status.register_progress()
        end
      '';

      # the lsp status plugin needs to hook into the on attach and capabilities
      # fields of the lsp setup call to track the progress of initializing the lsp
      onAttach = "require('lsp-status').on_attach(client)";
      capabilities = "capabilities = vim.tbl_extend('keep', capabilities or {}, require('lsp-status').capabilities)";
    };
  };
}
