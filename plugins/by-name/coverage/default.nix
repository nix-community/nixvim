{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.coverage;

  keymapsDef = {
    coverage = {
      command = "";
      description = "Loads a coverage report and immediately displays the coverage signs.";
    };
    load = {
      command = "Load";
      description = "Loads a coverage report but does not display the coverage signs.";
    };
    show = {
      command = "Show";
      description = ''
        Shows the coverage signs.
        Must call `:Coverage` or `:CoverageLoad` first.
      '';
    };
    hide = {
      command = "Hide";
      description = ''
        Hides the coverage signs.
        Must call `:Coverage` or `:CoverageLoad` first.
      '';
    };
    toggle = {
      command = "Toggle";
      description = ''
        Toggles the coverage signs.
        Must call `:Coverage` or `:CoverageLoad` first.
      '';
    };
    clear = {
      command = "Clear";
      description = ''
        Unloads the cached coverage signs.
        `:Coverage` or `:CoverageLoad` must be called again to relad the data.
      '';
    };
    summary = {
      command = "Summary";
      description = "Displays a coverage summary report in a floating window.";
    };
    loadLcov = {
      command = "LoadLcov";
      description = ''
        Loads a coverage report from an lcov file but does not display the coverage signs.
        Uses the lcov file configuration option.
      '';
    };
  };
in
{
  options.plugins.coverage = lib.nixvim.plugins.neovim.extraOptionsOptions // {
    enable = mkEnableOption "nvim-coverage";

    package = lib.mkPackageOption pkgs "nvim-coverage" {
      default = [
        "vimPlugins"
        "nvim-coverage"
      ];
    };

    keymapsSilent = mkOption {
      type = types.bool;
      description = "Whether nvim-coverage keymaps should be silent";
      default = false;
    };

    keymaps = mapAttrs (
      optionName: properties: helpers.mkNullOrOption types.str properties.description
    ) keymapsDef;

    autoReload = helpers.defaultNullOpts.mkBool false ''
      If true, the `coverage_file` for a language will be watched for changes after executing
      `:CoverageLoad` or `coverage.load()`.
      The file watcher will be stopped after executing `:CoverageClear` or `coverage.clear()`.
    '';

    autoReloadTimeoutMs = helpers.defaultNullOpts.mkInt 500 ''
      The number of milliseconds to wait before auto-reloading coverage after detecting a change.
    '';

    commands = helpers.defaultNullOpts.mkBool true "If true, create commands.";

    highlights = {
      covered = helpers.defaultNullOpts.mkAttributeSet {
        fg = "#B7F071";
      } "Highlight group for covered signs.";

      uncovered = helpers.defaultNullOpts.mkAttributeSet {
        fg = "#F07178";
      } "Highlight group for uncovered signs.";

      partial = helpers.defaultNullOpts.mkAttributeSet {
        fg = "#AA71F0";
      } "Highlight group for partial coverage signs.";

      summaryBorder = helpers.defaultNullOpts.mkAttributeSet {
        link = "FloatBorder";
      } "Border highlight group of the summary pop-up.";

      summaryNormal = helpers.defaultNullOpts.mkAttributeSet {
        link = "NormalFloat";
      } "Normal text highlight group of the summary pop-up.";

      summaryCursorLine = helpers.defaultNullOpts.mkAttributeSet {
        link = "CursorLine";
      } "Cursor line highlight group of the summary pop-up.";

      summaryHeader = helpers.defaultNullOpts.mkAttributeSet {
        style = "bold,underline";
        sp = "bg";
      } "Header text highlight group of the summary pop-up.";

      summaryPass = helpers.defaultNullOpts.mkAttributeSet {
        link = "CoverageCovered";
      } "Pass text highlight group of the summary pop-up.";

      summaryFail = helpers.defaultNullOpts.mkAttributeSet {
        link = "CoverageUncovered";
      } "Fail text highlight group of the summary pop-up.";
    };

    loadCoverageCb = helpers.defaultNullOpts.mkLuaFn' {
      description = "A lua function that will be called when a coverage file is loaded.";
      pluginDefault = "nil";
      example = ''
        function(ftype)
          vim.notify("Loaded " .. ftype .. " coverage")
        end
      '';
    };

    signs =
      mapAttrs
        (
          optionName:
          {
            prettyName ? optionName,
            defaults,
          }:
          {
            hl = helpers.defaultNullOpts.mkStr defaults.hl "The highlight group used for ${prettyName} signs.";

            text = helpers.defaultNullOpts.mkStr defaults.text "The text used for ${prettyName} signs.";
          }
        )
        {
          covered = {
            defaults = {
              hl = "CoverageCovered";
              text = "▎";
            };
          };
          uncovered = {
            defaults = {
              hl = "CoverageUncovered";
              text = "▎";
            };
          };
          partial = {
            prettyName = "partial coverage";
            defaults = {
              hl = "CoveragePartial";
              text = "▎";
            };
          };
        };

    signGroup = helpers.defaultNullOpts.mkStr "coverage" ''
      Name of the sign group used when placing the signs.
      See `:h sign-group`.
    '';

    summary = {
      widthPercentage =
        helpers.defaultNullOpts.mkNullable (types.numbers.between 0.0 1.0) 0.7
          "Width of the pop-up window.";

      heightPercentage =
        helpers.defaultNullOpts.mkNullable (types.numbers.between 0.0 1.0) 0.5
          "Height of the pop-up window.";

      borders = mapAttrs (optionName: default: helpers.defaultNullOpts.mkStr default "") {
        topleft = "╭";
        topright = "╮";
        top = "─";
        left = "│";
        right = "│";
        botleft = "╰";
        botright = "╯";
        bot = "─";
        highlight = "Normal:CoverageSummaryBorder";
      };

      minCoverage = helpers.defaultNullOpts.mkNullable (types.numbers.between 0 100) 80 ''
        Minimum coverage percentage.
        Values below this are highlighted with the fail group, values above are highlighted with
        the pass group.
      '';
    };

    lang = helpers.defaultNullOpts.mkAttributeSet' {
      description = ''
        Each key corresponds with the `filetype` of the language and maps to an attrs of
        configuration values that differ.

        See plugin documentation for language specific options.
      '';

      example = {
        python = {
          coverage_file = ".coverage";
          coverage_command = "coverage json --fail-under=0 -q -o -";
        };
        ruby = {
          coverage_file = "coverage/coverage.json";
        };
      };
    };

    lcovFile = helpers.mkNullOrOption types.str "File that the plugin will try to read lcov coverage from.";
  };

  config =
    let
      setupOptions =
        with cfg;
        {
          auto_reload = autoReload;
          auto_reload_timeout_ms = autoReloadTimeoutMs;
          inherit commands;
          highlights = with highlights; {
            inherit covered uncovered partial;
            summary_border = summaryBorder;
            summary_normal = summaryNormal;
            summary_cursor_line = summaryCursorLine;
            summary_header = summaryHeader;
            summary_pass = summaryPass;
            summary_fail = summaryFail;
          };
          load_coverage_cb = loadCoverageCb;
          inherit signs;
          sign_group = signGroup;
          summary = with summary; {
            width_percentage = widthPercentage;
            height_percentage = heightPercentage;
            inherit borders;
            min_coverage = minCoverage;
          };
          inherit lang;
          lcov_file = lcovFile;
        }
        // cfg.extraOptions;
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      extraConfigLua = ''
        require("coverage").setup(${lib.nixvim.toLuaObject setupOptions})
      '';

      keymaps = flatten (
        mapAttrsToList (
          optionName: properties:
          let
            key = cfg.keymaps.${optionName};
          in
          optional (key != null) {
            mode = "n";
            inherit key;
            action = ":Coverage${properties.command}<CR>";
            options.silent = cfg.keymapsSilent;
          }
        ) keymapsDef
      );
    };
}
