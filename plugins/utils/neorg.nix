{
  lib,
  helpers,
  config,
  pkgs,
  ...
}: let
  cfg = config.plugins.neorg;
in
  with lib; {
    options.plugins.neorg =
      helpers.extraOptionsOptions
      // {
        enable = mkEnableOption "neorg";

        package = helpers.mkPackageOption "neorg" pkgs.vimPlugins.neorg;

        lazyLoading =
          helpers.defaultNullOpts.mkBool false ''
          '';

        logger = let
          modes = {
            trace = {
              hl = "Comment";
              level = "trace";
            };
            debug = {
              hl = "Comment";
              level = "debug";
            };
            info = {
              hl = "None";
              level = "info";
            };
            warn = {
              hl = "WarningMsg";
              level = "warn";
            };
            error = {
              hl = "ErrorMsg";
              level = "error";
            };
            fatal = {
              hl = "ErrorMsg";
              level = 5;
            };
          };

          levelNames = attrNames modes;
        in {
          plugin = helpers.defaultNullOpts.mkStr "neorg" ''
            Name of the plugin. Prepended to log messages
          '';

          useConsole = helpers.defaultNullOpts.mkBool true ''
            Should print the output to neovim while running
          '';

          highlights = helpers.defaultNullOpts.mkBool true ''
            Should highlighting be used in console (using echohl)
          '';

          useFile = helpers.defaultNullOpts.mkBool true ''
            Should write to a file
          '';

          level = helpers.defaultNullOpts.mkEnum levelNames "warn" ''
            Any messages above this level will be logged
          '';

          modes =
            mapAttrs
            (mode: defaults: {
              hl = helpers.defaultNullOpts.mkStr defaults.hl ''
                Highlight for mode ${mode}
              '';
              level = mkOption {
                type = with types; either int (enum levelNames);
                default = defaults.level;
                description = "Level for mode ${mode}";
              };
            })
            modes;

          floatPrecision = helpers.defaultNullOpts.mkNullable types.float "0.01" ''
            Can limit the number of decimals displayed for floats
          '';
        };

        modules = mkOption {
          type = with types; attrsOf attrs;
          description = "Modules configuration.";
          default = {};
          example = {
            "core.defaults" = {__empty = null;};
            "core.dirman" = {
              config = {
                workspaces = {
                  work = "~/notes/work";
                  home = "~/notes/home";
                };
              };
            };
          };
        };
      };

    config = let
      setupOptions = with cfg;
        {
          lazy_loading = lazyLoading;

          logger = with logger; {
            inherit plugin;
            use_console = useConsole;
            inherit highlights;
            use_file = useFile;
            inherit level;

            modes =
              mapAttrsToList
              (mode: modeConfig: {
                name = mode;
                inherit (modeConfig) hl;
                level = let
                  inherit (modeConfig) level;
                in
                  if (isInt level)
                  then level
                  else helpers.mkRaw "vim.log.levels.${strings.toUpper level}";
              })
              modes;
            float_precision = floatPrecision;
          };

          load = modules;
        }
        // cfg.extraOptions;

      telescopeSupport = hasAttr "core.integrations.telescope" cfg.modules;
    in
      mkIf cfg.enable {
        warnings =
          (
            optional
            (telescopeSupport && (!config.plugins.telescope.enable))
            ''
              Telescope support for neorg (`core.integrations.telescope`) is enabled but the
              telescope plugin is not.
            ''
          )
          ++ (
            optional
            ((hasAttr "core.defaults" cfg.modules) && (!config.plugins.treesitter.enable))
            ''
              Neorg's `core.defaults` module is enabled but `plugins.treesitter` is not.
              Treesitter is required when using the `core.defaults`.
            ''
          );

        extraPlugins =
          [cfg.package]
          ++ (
            optional
            telescopeSupport
            pkgs.vimPlugins.neorg-telescope
          );

        extraConfigLua = ''
          require('neorg').setup(${helpers.toLuaObject setupOptions})
        '';
      };
  }
