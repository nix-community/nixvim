{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.todo-comments;

  commands = {
    todoQuickFix = "TodoQuickFix";
    todoLocList = "TodoLocList";
    todoTrouble = "TodoTrouble";
    todoTelescope = "TodoTelescope";
  };
in {
  imports = [
    (mkRemovedOptionModule [
      "plugins"
      "todo-comments"
      "keymapsSilent"
    ] "Use `plugins.todo-comments.keymaps.<COMMAND>.options.silent`.")
  ];
  options = {
    plugins.todo-comments =
      helpers.neovim-plugin.extraOptionsOptions
      // {
        enable = mkEnableOption "todo-comments";

        package = helpers.mkPluginPackageOption "todo-comments" pkgs.vimPlugins.todo-comments-nvim;

        ripgrepPackage = helpers.mkPackageOption {
          default = pkgs.ripgrep;
          description = "Which package (if any) to be added for file search support in todo-comments.";
        };

        signs = helpers.defaultNullOpts.mkBool true "Show icons in the signs column.";

        signPriority = helpers.defaultNullOpts.mkInt 8 "Sign priority.";

        keywords =
          helpers.mkNullOrOption
          (types.attrsOf (
            types.submodule {
              options = {
                icon = helpers.mkNullOrOption types.str ''
                  Icon used for the sign, and in search results.
                '';

                color = helpers.mkNullOrOption types.str ''
                  Can be a hex color, or a named color.
                '';

                alt = helpers.mkNullOrOption (types.listOf types.str) ''
                  A set of other keywords that all map to this FIX keywords.
                '';

                signs = helpers.mkNullOrOption types.bool ''
                  Configure signs for some keywords individually.
                '';
              };
            }
          ))
          ''
            Configurations for keywords to be recognized as todo comments.

            Default:
            ```nix
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

        guiStyle = {
          fg = helpers.defaultNullOpts.mkStr "NONE" ''
            The gui style to use for the fg highlight group.
          '';

          bg = helpers.defaultNullOpts.mkStr "BOLD" ''
            The gui style to use for the bg highlight group.
          '';
        };

        mergeKeywords = helpers.defaultNullOpts.mkBool true ''
          When true, custom keywords will be merged with the default
        '';

        highlight = {
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
            helpers.defaultNullOpts.mkNullable (with types; either str (listOf str)) ".*<(KEYWORDS)\\s*:"
            ''
              Pattern or list of patterns, used for highlighting (vim regex)

              Note: the provided pattern will be embedded as such: `[[PATTERN]]`.
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

        colors = helpers.mkNullOrOption (types.attrsOf (types.listOf types.str)) ''
          List of named colors where we try to extract the guifg from the list
          of highlight groups or use the hex color if hl not found as a fallback.

          Default:
          ```nix
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

        search = {
          command = helpers.defaultNullOpts.mkStr "rg" "Command to use for searching for keywords.";

          args = helpers.mkNullOrOption (types.listOf types.str) ''
            Arguments to use for the search command in list form.

            Default:
            ```nix
            [
              "--color=never"
              "--no-heading"
              "--with-filename"
              "--line-number"
              "--column"
            ];
            ```
          '';

          pattern = helpers.defaultNullOpts.mkStr "\\b(KEYWORDS):" ''
            Regex that will be used to match keywords.
            Don't replace the (KEYWORDS) placeholder.

            Note: the provided pattern will be embedded as such: `[[PATTERN]]`.
          '';
        };

        keymaps = let
          mkKeymapOption = optionName: funcName:
            helpers.mkCompositeOption "Keymap settings for the `:${funcName}` function." {
              key = mkOption {
                type = types.str;
                description = "Key for the `${funcName}` function.";
              };

              cwd = mkOption {
                type = types.nullOr types.str;
                description = "Specify the directory to search for comments";
                default = null;
                example = "~/projects/foobar";
              };

              keywords = mkOption {
                type = types.nullOr types.str;
                description = ''
                  Comma separated list of keywords to filter results by.
                  Keywords are case-sensitive.
                '';
                default = null;
                example = "TODO,FIX";
              };

              options = helpers.keymaps.mapConfigOptions;
            };
        in
          mapAttrs mkKeymapOption commands;
      };
  };

  config = let
    setupOptions =
      {
        inherit (cfg) signs;
        sign_priority = cfg.signPriority;
        inherit (cfg) keywords;
        gui_style = cfg.guiStyle;
        merge_keywords = cfg.mergeKeywords;
        highlight = {
          inherit
            (cfg.highlight)
            multiline
            before
            keyword
            after
            exclude
            ;
          pattern = helpers.ifNonNull' cfg.highlight.pattern (helpers.mkRaw "[[${cfg.highlight.pattern}]]");
          multiline_pattern = cfg.highlight.multilinePattern;
          multiline_context = cfg.highlight.multilineContext;
          comments_only = cfg.highlight.commentsOnly;
          max_line_len = cfg.highlight.maxLineLen;
        };
        inherit (cfg) colors;
        search = {
          inherit (cfg.search) command args;
          pattern = helpers.ifNonNull' cfg.search.pattern (
            if isList cfg.search.pattern
            then (map helpers.mkRaw cfg.search.pattern)
            else helpers.mkRaw "[[${cfg.search.pattern}]]"
          );
        };
      }
      // cfg.extraOptions;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];
      extraPackages = [cfg.ripgrepPackage];
      extraConfigLua = ''
        require("todo-comments").setup${helpers.toLuaObject setupOptions}
      '';

      keymaps = flatten (
        mapAttrsToList (
          optionName: funcName: let
            keymap = cfg.keymaps.${optionName};

            cwd = optionalString (keymap.cwd != null) " cwd=${keymap.cwd}";
            keywords = optionalString (keymap.keywords != null) " keywords=${keymap.keywords}";
          in
            optional (keymap != null) {
              mode = "n";
              inherit (keymap) key options;
              action = ":${funcName}${cwd}${keywords}<CR>";
            }
        )
        commands
      );

      # Automatically enable plugins if keymaps have been set
      plugins = mkMerge [
        (mkIf (cfg.keymaps.todoTrouble != null) {trouble.enable = true;})
        (mkIf (cfg.keymaps.todoTelescope != null) {telescope.enable = true;})
      ];
    };
}
