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
    enable = mkEnableOption "telescope.nvim";

    package = mkOption {
      type = types.package;
      default = pkgs.vimPlugins.telescope-nvim;
      description = "Plugin to use for telescope.nvim";
    };

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

    defaults = mkOption {
      type = types.nullOr types.attrs;
      default = null;
      description = "Telescope default configuration";
    };

    extraOptions = mkOption {
      type = types.attrs;
      default = { };
      description = "An attribute set, that lets you set extra options or override options set by nixvim";
    };
  };

  config = mkIf cfg.enable {
    extraPackages = [ pkgs.bat ];

    extraPlugins = with pkgs.vimPlugins; [
      cfg.package
      plenary-nvim
      popup-nvim
    ];

    extraConfigVim = mkIf (cfg.highlightTheme != null) ''
      let $BAT_THEME = '${cfg.highlightTheme}'
    '';

    extraConfigLua =
      let
        options = {
          extensions = cfg.extensionConfig;
          defaults = cfg.defaults;
        } // cfg.extraOptions;
      in
      ''
        do
          local __telescopeExtensions = ${helpers.toLuaObject cfg.enabledExtensions}

          require('telescope').setup(${helpers.toLuaObject options})

          for i, extension in ipairs(__telescopeExtensions) do
            require('telescope').load_extension(extension)
          end
        end
      '';
  };
}
