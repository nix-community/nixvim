{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.programs.nixvim.plugins.telescope;
in
{
  # TODO Add support for aditional filetypes. This requires autocommands!

  options.programs.nixvim.plugins.telescope = {
    enable = mkEnableOption "Enable telescope.nvim";

    highlightTheme = mkOption {
      default = config.programs.nixvim.colorscheme;
      type = types.nullOr types.str;
      description = "The colorscheme to use for syntax highlighting";
    };

    extensions = {
      frecency = {
        enable = mkEnableOption "Enable telescope-frecency";
      };
    };
  };

  config = let
    extensionPlugins = with cfg.extensions; with pkgs.vimPlugins;
    (optional frecency.enable telescope-frecency-nvim) ++
    (optional frecency.enable sqlite-lua);

    extensionPackages = with cfg.extensions; with pkgs;
    (optional frecency.enable sqlite);

    extensions = with cfg.extensions;
    (optional frecency.enable "frecency");

    loadExtensions = "require('telescope')" + (concatMapStrings (e: ".load_extension('${e}')") extensions);
  in mkIf cfg.enable {
    programs.nixvim = {
      extraPackages = with pkgs; [
        bat
      ] ++ extensionPackages;

      extraPlugins = with pkgs.vimPlugins; [
        telescope-nvim
        plenary-nvim
        popup-nvim
      ] ++ extensionPlugins;

      extraConfigVim = mkIf (cfg.highlightTheme != null) ''
        let $BAT_THEME = '${cfg.highlightTheme}'
      '';

      extraConfigLua = mkIf (extensions != []) loadExtensions;
    };
  };
}
