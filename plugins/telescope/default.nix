{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.telescope;
  helpers = import ../helpers.nix {inherit lib;};
in {
  imports = [
    ./file-browser.nix
    ./frecency.nix
    ./fzf-native.nix
    ./fzy-native.nix
    ./media-files.nix
    ./project-nvim.nix
  ];

  # TODO:add support for aditional filetypes. This requires autocommands!

  options.plugins.telescope =
    helpers.extraOptionsOptions
    // {
      enable = mkEnableOption "telescope.nvim";

      package = helpers.mkPackageOption "telescope.nvim" pkgs.vimPlugins.telescope-nvim;

      keymaps = mkOption {
        type = types.attrsOf types.str;
        description = "Keymaps for telescope.";
        default = {};
        example = {
          "<leader>fg" = "live_grep";
          "<C-p>" = "git_files";
        };
      };

      keymapsSilent = mkOption {
        type = types.bool;
        description = "Whether telescope keymaps should be silent";
        default = false;
      };

      highlightTheme = mkOption {
        type = types.nullOr types.str;
        description = "The colorscheme to use for syntax highlighting";
        default = config.colorscheme;
      };

      enabledExtensions = mkOption {
        type = types.listOf types.str;
        description = "A list of enabled extensions. Don't use this directly";
        default = [];
      };

      extensionConfig = mkOption {
        type = types.attrsOf types.anything;
        description = "Configuration for the extensions. Don't use this directly";
        default = {};
      };

      defaults = mkOption {
        type = types.nullOr types.attrs;
        default = null;
        description = "Telescope default configuration";
      };
    };

  config = mkIf cfg.enable {
    extraPackages = [pkgs.bat];

    extraPlugins = with pkgs.vimPlugins; [
      cfg.package
      plenary-nvim
      popup-nvim
    ];

    extraConfigVim = mkIf (cfg.highlightTheme != null) ''
      let $BAT_THEME = '${cfg.highlightTheme}'
    '';

    maps.normal =
      mapAttrs
      (key: action: {
        silent = cfg.keymapsSilent;
        action = "require('telescope.builtin').${action}";
        lua = true;
      })
      cfg.keymaps;

    extraConfigLua = let
      options =
        {
          extensions = cfg.extensionConfig;
          inherit (cfg) defaults;
        }
        // cfg.extraOptions;
    in ''
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
