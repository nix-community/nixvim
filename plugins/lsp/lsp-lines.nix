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

      package = helpers.mkPluginPackageOption "lsp_lines.nvim" pkgs.vimPlugins.lsp_lines-nvim;

      currentLine = mkOption {
        type = types.bool;
        default = false;
        description = "Show diagnostics only on current line.";
      };

      disableVirtualText = mkOption {
        type = types.bool;
        default = false;
        description = "Hide virtual text.";
      };
    };
  };

  config =
    let
      vlineConfig = {
        virtual_lines = if cfg.currentLine then { only_current_line = true; } else true;
      };
      vtextConfig = {
        virtual_text = false;
      };
      diagnosticConfig = if cfg.disableVirtualText then vlineConfig // vtextConfig else vlineConfig;
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
