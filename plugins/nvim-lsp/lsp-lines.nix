{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.plugins.lsp-lines;
  helpers = import ../helpers.nix { lib = lib; };
in
{
  options = {
    plugins.lsp-lines = {
      enable = mkEnableOption "lsp_lines.nvim";
    };
  };

  config =
    mkIf cfg.enable {
      extraPlugins = [ pkgs.vimPlugins.lsp_lines-nvim ];

      extraConfigLua = ''
        do
          require("lsp_lines").setup()

          vim.diagnostic.config({
            virtual_text = false
          })
        end
      '';
    };
}
