{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.plugins.telescope;
  helpers = (import ../helpers.nix { inherit lib; });
in
{
  imports = [
    ./frecency.nix
    ./fzf-native.nix
    ./fzy-native.nix
    ./media-files.nix
    ./project-nvim.nix
  ];

  # TODO:add support for aditional filetypes. This requires autocommands!

  options.plugins.telescope = {
    enable = mkEnableOption "Enable telescope.nvim";

    highlightTheme = mkOption {
      type = types.nullOr types.str;
      description = "The colorscheme to use for syntax highlighting";
      default = config.colorscheme;
    };

    enabledExtensions = mkOption {
      type = types.listOf types.str;
      description = "A list of enabled extensions. Don't use this directly";
      default = [ ];
    };

    extensionConfig = mkOption {
      type = types.attrsOf types.anything;
      description = "Configuration for the extensions. Don't use this directly";
      default = { };
    };
  };

  config = mkIf cfg.enable {
    extraPackages = [ pkgs.bat ];

    extraPlugins = with pkgs.vimPlugins; [
      telescope-nvim
      plenary-nvim
      popup-nvim
    ];

    extraConfigVim = mkIf (cfg.highlightTheme != null) ''
      let $BAT_THEME = '${cfg.highlightTheme}'
    '';

    extraConfigLua = ''
      do
        local __telescopeExtensions = ${helpers.toLuaObject cfg.enabledExtensions}

        require('telescope').setup{
          extensions = ${helpers.toLuaObject cfg.extensionConfig}
        }

        for i, extension in ipairs(__telescopeExtensions) do
          require('telescope').load_extension(extension)
        end
      end
    '';
  };
}
