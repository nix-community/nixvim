{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.programs.nixvim.plugins.lsp-lines;
  helpers = import ../helpers.nix { lib = lib; };
in
{
  options = {
    programs.nixvim.plugins.lsp-lines = {
      enable = mkEnableOption "lsp_lines.nvim";
    };
  };

  config.programs.nixvim =
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
