{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
# TODO:add support for additional filetypes. This requires autocommands!
  helpers.neovim-plugin.mkNeovimPlugin config {
    name = "telescope";
    originalName = "telescope.nvim";
    defaultPackage = pkgs.vimPlugins.telescope-nvim;

    maintainers = [maintainers.GaetanLepage];

    extraPackages = [pkgs.bat];

    # TODO introduced 2024-03-24: remove 2024-05-24
    deprecateExtraOptions = true;
    optionsRenamedToSettings = ["defaults"];

    imports = [./extensions];

    extraOptions = {
      keymaps = mkOption {
        type = with types;
          attrsOf (
            either str (submodule {
              options = {
                action = mkOption {type = types.str;};
                mode = helpers.keymaps.mkModeOption "n";
                options = helpers.keymaps.mapConfigOptions;
              };
            })
          );
        description = "Keymaps for telescope.";
        default = {};
        example = {
          "<leader>fg" = "live_grep";
          "<C-p>" = {
            action = "git_files";
            options.desc = "Telescope Git Files";
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
    };

    callSetup = false;
    extraConfig = cfg: {
      extraConfigVim = mkIf (cfg.highlightTheme != null) ''
        let $BAT_THEME = '${cfg.highlightTheme}'
      '';

      keymaps =
        mapAttrsToList (
          key: mapping: let
            actionStr =
              if isString mapping
              then mapping
              else mapping.action;
          in {
            mode = mapping.mode or "n";
            inherit key;
            action.__raw = "require('telescope.builtin').${actionStr}";

            options =
              {
                silent = cfg.keymapsSilent;
              }
              // (mapping.options or {});
          }
        )
        cfg.keymaps;

      extraConfigLua = ''
        require('telescope').setup(${helpers.toLuaObject cfg.settings})

        local __telescopeExtensions = ${helpers.toLuaObject cfg.enabledExtensions}
        for i, extension in ipairs(__telescopeExtensions) do
          require('telescope').load_extension(extension)
        end
      '';
    };

    settingsOptions = {
      defaults = helpers.mkNullOrOption (with types; attrsOf anything) ''
        Default configuration for telescope.
      '';

      pickers = helpers.mkNullOrOption (with types; attrsOf anything) ''
        Default configuration for builtin pickers.
      '';

      extensions = mkOption {
        type = with types; attrsOf anything;
        default = {};
        # NOTE: We hide this option from the documentation as users should use the top-level
        # `extensions.*` options.
        # They can still directly change this `settings.adapters` option.
        # In this case, they are responsible for explicitly installing the manually added extensions.
        visible = false;
      };
    };

    settingsExample = {
      defaults = {
        file_ignore_patterns = [
          "^.git/"
          "^.mypy_cache/"
          "^__pycache__/"
          "^output/"
          "^data/"
          "%.ipynb"
        ];
        set_env.COLORTERM = "truecolor";
        sorting_strategy = "ascending";
        selection_caret = "> ";
        layout_config.prompt_position = "top";
        mappings = {
          i = {
            "<A-j>".__raw = "require('telescope.actions').move_selection_next";
            "<A-k>".__raw = "require('telescope.actions').move_selection_previous";
          };
        };
      };
    };
  }
