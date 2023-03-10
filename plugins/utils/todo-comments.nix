{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.todo-comments;
  helpers = import ../helpers.nix {inherit lib;};
in {
  options = {
    plugins.todo-comments =
      helpers.extraOptionsOptions
      // {
        enable = mkEnableOption "Enable todo-comments.";

        package =
          helpers.mkPackageOption
          "todo-comments"
          pkgs.vimPlugins.todo-comments-nvim;

        signs = helpers.defaultNullOpts.mkBool true ''
          Show icons in the signs column.
        '';

        signPriority = helpers.defaultNullOpts.mkInt 8 "Sign priority.";

        keywords = helpers.mkNullOrOption (types.nullOr types.attrs) ''
          Configurations for keywords to be recognized as todo comments.

          Default:
          ```
          {
            FIX = {
              icon = " "; # Icon used for the sign, and in search results.
              color = "error"; # Can be a hex color, or a named color.
              alt = [ "FIXME" "BUG" "FIXIT" "ISSUE" ]; # A set of other keywords that all map to this FIX keywords.
            };
            TODO = { icon = " "; color = "info"; };
            HACK = { icon = " "; color = "warning"; };
            WARN = { icon = " "; color = "warning"; alt = [ "WARNING" "XXX" ]; };
            PERF = { icon = " "; alt = [ "OPTIM" "PERFORMANCE" "OPTIMIZE" ]; };
            NOTE = { icon = " "; color = "hint"; alt = [ "INFO" ]; };
            TEST = { icon = "⏲ "; color = "test"; alt = [ "TESTING" "PASSED" "FAILED" ]; };
          };
          ```
        '';

        guiStyle = mkOption {
          description = "The gui style for highlight groups.";
          default = null;
          type = types.nullOr (types.submodule ({...}: {
            options = {
              fg = helpers.defaultNullOpts.mkStr "NONE" ''
                The gui style to use for the fg highlight group.
              '';
              bg = helpers.defaultNullOpts.mkStr "BOLD" ''
                The gui style to use for the bg highlight group.
              '';
            };
          }));
        };

        mergeKeywords = helpers.defaultNullOpts.mkBool true ''
          When true, custom keywords will be merged with the default
        '';

        highlight = mkOption {
          description = "Highlight options";
          default = null;
          type = types.nullOr (types.submodule ({...}: {
            options = {
              multiline = helpers.defaultNullOpts.mkBool true ''
                Enable multiline todo comments.
              '';

              multilinePattern = helpers.defaultNullOpts.mkStr "^." ''
                Lua pattern to match the next multiline from the start of the
                matched keyword.
              '';

              multilineContext = helpers.defaultNullOpts.mkInt 10 ''
                Extra lines that will be re-evaluated when changing a line.
              '';

              before = helpers.defaultNullOpts.mkStr "" ''
                "fg" or "bg" or empty.
              '';

              keyword = helpers.defaultNullOpts.mkStr "wide" ''
                "fg", "bg", "wide", "wide_bg", "wide_fg" or empty.
                (wide and wide_bg is the same as bg, but will also highlight
                surrounding characters, wide_fg acts accordingly but with fg).
              '';

              after = helpers.defaultNullOpts.mkStr "fg" ''
                "fg" or "bg" or empty.
              '';

              pattern =
                helpers.mkNullOrOption
                (types.oneOf [types.str (types.listOf types.str)]) ''
                  Pattern or list of patterns, used for highlighting (vim regex)
                '';

              commentsOnly = helpers.defaultNullOpts.mkBool true ''
                Uses treesitter to match keywords in comments only.
              '';

              maxLineLen = helpers.defaultNullOpts.mkInt 400 ''
                Ignore lines longer than this.
              '';

              exclude = helpers.mkNullOrOption (types.listOf types.str) ''
                List of file types to exclude highlighting.
              '';
            };
          }));
        };

        colors =
          helpers.mkNullOrOption
          (types.attrsOf (types.listOf types.str)) ''
            List of named colors where we try to extract the guifg from the list
            of highlight groups or use the hex color if hl not found as a fallback.

            Default:
            ```
            {
              error = [ "DiagnosticError" "ErrorMsg" "#DC2626" ];
              warning = [ "DiagnosticWarn" "WarningMsg" "#FBBF24" ];
              info = [ "DiagnosticInfo" "#2563EB" ];
              hint = [ "DiagnosticHint" "#10B981" ];
              default = [ "Identifier" "#7C3AED" ];
              test = [ "Identifier" "#FF00FF" ];
            };
            ```
          '';

        search = mkOption {
          description = "Search options.";
          default = null;
          type = types.nullOr (types.submodule ({...}: {
            options = {
              command = helpers.defaultNullOpts.mkStr "rg" ''
                Command to use for searching for keywords.
              '';
              args = helpers.mkNullOrOption (types.listOf types.str) ''
                Arguments to use for the search command in list form.

                Default:
                ```
                [
                  "--color=never"
                  "--no-heading"
                  "--with-filename"
                  "--line-number"
                  "--column"
                ];
                ```
              '';
              pattern = helpers.defaultNullOpts.mkStr "[[\b(KEYWORDS):]]" ''
                Regex that will be used to match keywords.
                Don't replace the (KEYWORDS) placeholder.
              '';
            };
          }));
        };
      };
  };

  config = let
    setupOptions =
      {
        signs = cfg.signs;
        signPriority = cfg.signPriority;
        keywords = cfg.keywords;
        guiStyle = cfg.guiStyle;
        mergeKeywords = cfg.mergeKeywords;
        highlight = cfg.highlight;
        colors = cfg.colors;
        search = cfg.search;
      }
      // cfg.extraOptions;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];
      extraConfigLua = ''
        require("todo-comments").setup${helpers.toLuaObject setupOptions}
      '';
    };
}
