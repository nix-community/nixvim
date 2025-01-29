{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib.nixvim)
    defaultNullOpts
    mkNullOrStr
    mkNullOrOption
    mkNullOrOption'
    ;
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "neorg";

  maintainers = [ lib.maintainers.GaetanLepage ];

  # TODO introduced 2024-12-12: remove after 25.05
  deprecateExtraOptions = true;
  optionsRenamedToSettings = [
    "lazyLoading"
    [
      "logger"
      "plugin"
    ]
    [
      "logger"
      "useConsole"
    ]
    [
      "logger"
      "highlights"
    ]
    [
      "logger"
      "useFile"
    ]
    [
      "logger"
      "level"
    ]
    [
      "logger"
      "floatPrecision"
    ]
    {
      old = "modules";
      new = "load";
    }
  ];
  imports = [
    ./deprecations.nix
  ];

  extraOptions = {
    telescopeIntegration = {
      enable = lib.mkEnableOption "`neorg-telescope` plugin for telescope integration.";

      package = lib.mkPackageOption pkgs "neorg-telescope" {
        default = [
          "vimPlugins"
          "neorg-telescope"
        ];
      };
    };
  };

  settingsOptions = {
    hook = mkNullOrOption types.rawLua ''
      A user-defined function that is invoked whenever Neorg starts up. May be used to e.g. set custom keybindings.

      ```lua
      fun(manual: boolean, arguments?: string)
      ```
    '';

    lazy_loading = defaultNullOpts.mkBool false ''
      Whether to defer loading the Neorg core until after the user has entered a `.norg` file.
    '';

    load = defaultNullOpts.mkAttrsOf' {
      description = ''
        A list of modules to load, alongside their configurations.
      '';
      example = {
        "core.defaults".__empty = null;
        "core.concealer".config = {
          icon_preset = "varied";
        };
        "core.dirman".config = {
          workspaces = {
            work = "~/notes/work";
            home = "~/notes/home";
          };
        };
      };
      pluginDefault = { };
      type = types.anything;
    };

    logger = {
      plugin = defaultNullOpts.mkStr "neorg" ''
        Name of the plugin.
        Prepended to log messages.
      '';

      use_console = defaultNullOpts.mkBool true ''
        Whether to print the output to Neovim while running.
      '';

      highlights = defaultNullOpts.mkBool true ''
        Whether highlighting should be used in console (using `:echohl`).
      '';

      use_file = defaultNullOpts.mkBool true ''
        Whether to write output to a file.
      '';

      level = defaultNullOpts.mkStr "warn" ''
        Any messages above this level will be logged.
      '';

      modes = defaultNullOpts.mkListOf' {
        description = ''
          Level configuration.
        '';
        type = types.submodule {
          freeformType = with types; attrsOf anything;
          options = {
            name = mkNullOrStr ''
              Name for this log level.
            '';

            hl = mkNullOrStr ''
              highlight group.
            '';

            level = mkNullOrOption' {
              type = with types; maybeRaw (either ints.unsigned str);
              description = ''
                Log level value.
              '';
              example.__raw = "vim.log.levels.TRACE";
            };
          };
        };
        pluginDefault = [
          {
            name = "trace";
            hl = "Comment";
            level.__raw = "vim.log.levels.TRACE";
          }
          {
            name = "debug";
            hl = "Comment";
            level.__raw = "vim.log.levels.DEBUG";
          }
          {
            name = "info";
            hl = "None";
            level.__raw = "vim.log.levels.INFO";
          }
          {
            name = "warn";
            hl = "WarningMsg";
            level.__raw = "vim.log.levels.WARN";
          }
          {
            name = "error";
            hl = "ErrorMsg";
            level.__raw = "vim.log.levels.ERROR";
          }
          {
            name = "fatal";
            hl = "ErrorMsg";
            level = 5;
          }
        ];
      };

      float_precision = defaultNullOpts.mkFloat 0.01 ''
        Can limit the number of decimals displayed for floats.
      '';
    };
  };

  settingsExample = {
    load = {
      "core.defaults".__empty = null;
      "core.concealer".config = {
        icon_preset = "varied";
      };
      "core.dirman".config = {
        workspaces = {
          work = "~/notes/work";
          home = "~/notes/home";
        };
      };
    };
  };

  extraConfig = cfg: {

    extraPlugins = lib.mkIf cfg.telescopeIntegration.enable [ cfg.telescopeIntegration.package ];

    warnings =
      let
        modules = cfg.settings.load or { };
        telescopeModuleEnabled = (modules."core.integrations.telescope" or null) != null;
      in
      lib.nixvim.mkWarnings "plugins.neorg" [
        {
          when = telescopeModuleEnabled && (!cfg.telescopeIntegration.enable);
          message = ''
            You have enabled the telescope neorg module (`core.integrations.telescope`) but have not enabled `plugins.neorg.telescopeIntegration.enable`.
            The latter will install the `neorg-telescope` plugin necessary for this integration to work.
          '';
        }
        {
          when = cfg.telescopeIntegration.enable && (!config.plugins.telescope.enable);
          message = ''
            Telescope support for neorg is enabled but the telescope plugin is not.
          '';
        }
        {
          when = (modules ? "core.defaults") && (!config.plugins.treesitter.enable);
          message = ''
            Neorg's `core.defaults` module is enabled but `plugins.treesitter` is not.
            Treesitter is required when using the `core.defaults`.
          '';
        }
      ];
  };
}
