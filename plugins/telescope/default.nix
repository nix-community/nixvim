{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  inherit (lib.nixvim)
    keymaps
    mkNullOrOption
    mkPackageOption
    toLuaObject
    ;
in
# TODO:add support for additional filetypes. This requires autocommands!
lib.nixvim.neovim-plugin.mkNeovimPlugin config {
  name = "telescope";
  originalName = "telescope.nvim";
  defaultPackage = pkgs.vimPlugins.telescope-nvim;

  maintainers = [ maintainers.GaetanLepage ];

  extraPackages = [ pkgs.bat ];

  # TODO introduced 2024-03-24: remove 2024-05-24
  deprecateExtraOptions = true;
  optionsRenamedToSettings = [ "defaults" ];

  imports = [
    ./extensions

    # TODO introduced 2024-05-24: remove 2024-08-24
    (mkRemovedOptionModule
      [
        "plugins"
        "telescope"
        "keymapsSilent"
      ]
      "This option no longer has any effect now that the `plugin.telescope.keymaps` implementation uses `<cmd>`."
    )
  ];

  extraOptions = {
    keymaps = mkOption {
      type =
        with types;
        attrsOf (
          either str (submodule {
            options = {
              action = mkOption {
                type = types.str;
                description = "The telescope action to run.";
              };
              mode = keymaps.mkModeOption "n";
              options = keymaps.mapConfigOptions;
            };
          })
        );
      description = "Keymaps for telescope.";
      default = { };
      example = {
        "<leader>fg" = "live_grep";
        "<C-p>" = {
          action = "git_files";
          options.desc = "Telescope Git Files";
        };
      };
    };

    highlightTheme = mkOption {
      type = types.nullOr types.str;
      description = "The colorscheme to use for syntax highlighting";
      default = config.colorscheme;
    };

    enabledExtensions = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        A list of enabled extensions.

        You should only use this option directly if the Telescope extension you wish to enable is not natively supported
        by nixvim.

        Most extensions are available as `plugins.telescope.extensions.<name>.enable`, although some plugins that do
        more than just provide Telescope extensions may use `plugins.<name>.enableTelescope` instead.

        If you add an extension to this list manually, it is your responsibility to ensure the relevant plugin is also
        added to `extraPackages`.
      '';
    };

    iconsPackage = mkPackageOption {
      name = "nvim-web-devicons";
      default = pkgs.vimPlugins.nvim-web-devicons;
    };
  };

  callSetup = false;
  extraConfig = cfg: {
    extraPlugins = mkIf (cfg.iconsPackage != null) [ cfg.iconsPackage ];

    extraConfigVim = mkIf (cfg.highlightTheme != null) ''
      let $BAT_THEME = '${cfg.highlightTheme}'
    '';

    keymaps = mapAttrsToList (
      key: mapping:
      let
        actionStr = if isString mapping then mapping else mapping.action;
      in
      {
        mode = mapping.mode or "n";
        inherit key;
        action = "<cmd>Telescope ${actionStr}<cr>";
        options = mapping.options or { };
      }
    ) cfg.keymaps;

    extraConfigLua = ''
      require('telescope').setup(${toLuaObject cfg.settings})

      local __telescopeExtensions = ${toLuaObject cfg.enabledExtensions}
      for i, extension in ipairs(__telescopeExtensions) do
        require('telescope').load_extension(extension)
      end
    '';

    # planets picker requires files in data/memes/planets
    performance.combinePlugins.pathsToLink = [ "/data/memes/planets" ];
  };

  settingsOptions = {
    defaults = mkNullOrOption (with types; attrsOf anything) ''
      Default configuration for telescope.
    '';

    pickers = mkNullOrOption (with types; attrsOf anything) ''
      Default configuration for builtin pickers.
    '';

    extensions = mkOption {
      type = with types; attrsOf anything;
      default = { };
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
