{
  pkgs,
  lib,
  config,
  helpers,
  ...
}:
with lib; {
  options.plugins.nvim-lightbulb = {
    enable = mkEnableOption "nvim-lightbulb, showing available code actions";

    package = mkOption {
      type = types.package;
      default = pkgs.vimPlugins.nvim-lightbulb;
      description = "Plugin to use for nvim-lightbulb";
    };

    ignore = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" ''
      LSP client names to ignore
    '';

    sign = {
      enabled = helpers.defaultNullOpts.mkBool true "";
      priority = helpers.defaultNullOpts.mkInt 10 "";
    };

    float = {
      enabled = helpers.defaultNullOpts.mkBool false "";

      text = helpers.defaultNullOpts.mkStr "💡" "Text to show in the popup float";

      winOpts = helpers.defaultNullOpts.mkNullable (types.attrsOf types.anything) "{}" ''
        Options for the floating window (see |vim.lsp.util.open_floating_preview| for more information)
      '';
    };

    virtualText = {
      enabled = helpers.defaultNullOpts.mkBool false "";

      text = helpers.defaultNullOpts.mkStr "💡" "Text to show at virtual text";

      hlMode = helpers.defaultNullOpts.mkStr "replace" ''
        highlight mode to use for virtual text (replace, combine, blend), see
        :help nvim_buf_set_extmark() for reference
      '';
    };

    statusText = {
      enabled = helpers.defaultNullOpts.mkBool false "";

      text = helpers.defaultNullOpts.mkStr "💡" "Text to provide when code actions are available";

      textUnavailable = helpers.defaultNullOpts.mkStr "" ''
        Text to provide when no actions are available
      '';
    };

    autocmd = {
      enabled = helpers.defaultNullOpts.mkBool false "";

      pattern = helpers.defaultNullOpts.mkNullable (types.listOf types.str) ''["*"]'' "";

      events =
        helpers.defaultNullOpts.mkNullable (types.listOf types.str)
        ''["CursorHold" "CursorHoldI"]'' "";
    };
  };

  config = let
    cfg = config.plugins.nvim-lightbulb;
    setupOptions = {
      inherit (cfg) ignore sign autocmd;
      float = {
        inherit (cfg.float) enabled text;
        win_opts = cfg.float.winOpts;
      };
      virtual_text = {
        inherit (cfg.virtualText) enabled text;
        hl_mode = cfg.virtualText.hlMode;
      };
      status_text = {
        inherit (cfg.statusText) enabled text;
        text_unavailable = cfg.statusText.textUnavailable;
      };
    };
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];
      extraConfigLua = ''
        require("nvim-lightbulb").setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
