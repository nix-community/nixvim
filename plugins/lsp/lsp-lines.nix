{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.lsp-lines;
in
{
  options = {
    plugins.lsp-lines = {
      enable = mkEnableOption "lsp_lines.nvim";

      package = helpers.mkPackageOption "lsp_lines.nvim" pkgs.vimPlugins.lsp_lines-nvim;

      currentLine = mkOption {
        type = types.bool;
        default = false;
        description = "Show diagnostics only on current line";
      };
    };
  };

  config =
    let
      diagnosticConfig = {
        virtual_text = false;
        virtual_lines = if cfg.currentLine then { only_current_line = true; } else true;
      };
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      extraConfigLua = ''
        do
          require("lsp_lines").setup()

          vim.diagnostic.config(${helpers.toLuaObject diagnosticConfig})
        end
      '';
    };
}
