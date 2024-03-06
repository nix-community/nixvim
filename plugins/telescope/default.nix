{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.telescope;
in {
  imports = [
    ./file-browser.nix
    ./frecency.nix
    ./fzf-native.nix
    ./fzy-native.nix
    ./media-files.nix
    ./project-nvim.nix
    ./ui-select.nix
    ./undo.nix
  ];

  # TODO:add support for additional filetypes. This requires autocommands!

  options.plugins.telescope =
    helpers.neovim-plugin.extraOptionsOptions
    // {
      enable = mkEnableOption "telescope.nvim";

      package = helpers.mkPackageOption "telescope.nvim" pkgs.vimPlugins.telescope-nvim;

      keymaps = mkOption {
        type = with types; attrsOf (either str attrs);
        description = "Keymaps for telescope.";
        default = {};
        example = {
          "<leader>fg" = "live_grep";
          "<C-p>" = {
            action = "git_files";
            desc = "Telescope Git Files";
          };
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
        internal = true;
        visible = false;
      };

      extensionConfig = mkOption {
        type = types.attrsOf types.anything;
        description = "Configuration for the extensions. Don't use this directly";
        default = {};
        internal = true;
        visible = false;
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

    keymaps =
      mapAttrsToList
      (
        key: action: let
          actionStr =
            if isString action
            then action
            else action.action;
          actionProps =
            if isString action
            then {}
            else filterAttrs (n: v: n != "action") action;
        in {
          mode = "n";
          inherit key;
          action.__raw = "require('telescope.builtin').${actionStr}";

          options =
            {
              silent = cfg.keymapsSilent;
            }
            // actionProps;
        }
      )
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
