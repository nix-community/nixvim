{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.plugins.neorg;
  helpers = import ../helpers.nix {inherit lib;};
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
              level = "5";
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
              level =
                helpers.defaultNullOpts.mkNullable
                (with types; either int (enum levelNames))
                defaults.level
                "Level for mode ${mode}";
            })
            modes;

          floatPrecision = helpers.defaultNullOpts.mkNullable types.float "0.01" ''
            Can limit the number of decimals displayed for floats
          '';
        };

        modules = helpers.mkNullOrOption (types.attrsOf types.attrs) ''
          Modules configuration.

          Example:

          modules = {
            "core.defaults" = {};
            "core.norg.dirman" = {
              config = {
                workspaces = {
                    work = "~/notes/work";
                    home = "~/notes/home";
                };
              };
            };
          };
        '';
      };

    config = let
      options =
        {
          lazy_loading = cfg.lazyLoading;

          logger = {
            plugin = cfg.logger.plugin;
            use_console = cfg.logger.useConsole;
            highlights = cfg.logger.highlights;
            use_file = cfg.logger.useFile;
            level = cfg.logger.level;

            modes =
              attrsets.mapAttrsToList
              (mode: modeConfig: {
                name = mode;
                inherit (modeConfig) hl;
                level = let
                  level = modeConfig.level;
                in
                  if (isInt level)
                  then level
                  else helpers.mkRaw "vim.log.levels.${string.toUpper level}";
              })
              cfg.logger.modes;
            float_precision = cfg.logger.floatPrecision;
          };

          load = cfg.modules;
        }
        // cfg.extraOptions;
    in
      mkIf cfg.enable {
        extraPlugins = [cfg.package];

        extraConfigLua = ''
          require('nvim-tree').setup(${helpers.toLuaObject options})
        '';
      };
  }
