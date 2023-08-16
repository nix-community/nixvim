{
  lib,
  pkgs,
  config,
  ...
} @ args:
with lib; let
  helpers = import ../helpers.nix args;
in {
  options.plugins.indent-blankline = {
    enable = mkEnableOption "indent-blankline.nvim";

    package = helpers.mkPackageOption "indent-blankline" pkgs.vimPlugins.indent-blankline-nvim;

    char = helpers.defaultNullOpts.mkStr "│" ''
      Specifies the character to be used as indent line. Not used if charList is not empty.

      When set explicitly to empty string (""), no indentation character is displayed at all,
      even when 'charList' is not empty. This can be useful in combination with
      spaceCharHighlightList to only rely on different highlighting of different indentation
      levels without needing to show a special character.
    '';

    charBlankline = helpers.defaultNullOpts.mkStr "" ''
      Specifies the character to be used as indent line for blanklines. Not used if
      charListBlankline is not empty.
    '';

    charList = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" ''
      Specifies a list of characters to be used as indent line for
      each indentation level.
      Ignored if the value is an empty list.
    '';

    charListBlankline = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" ''
      Specifies a list of characters to be used as indent line for
      each indentation level on blanklines.
      Ignored if the value is an empty list.
    '';

    charHighlightList = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" ''
      Specifies the list of character highlights for each indentation level.
      Ignored if the value is an empty list.
    '';

    spaceCharBlankline = helpers.defaultNullOpts.mkStr " " ''
      Specifies the character to be used as the space value in between indent
      lines when the line is blank.
    '';

    spaceCharHighlightList = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" ''
      Specifies the list of space character highlights for each indentation
      level.
      Ignored if the value is an empty list.
    '';

    spaceCharBlanklineHighlightList = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" ''
      Specifies the list of space character highlights for each indentation
      level when the line is empty.
      Ignored if the value is an empty list.
    '';

    useTreesitter =
      helpers.defaultNullOpts.mkBool false
      "Use treesitter to calculate indentation when possible.";

    indentLevel = helpers.defaultNullOpts.mkInt 10 "Specifies the maximum indent level to display.";

    maxIndentIncrease = helpers.defaultNullOpts.mkInt config.plugins.indent-blankline.indentLevel ''
      The maximum indent level increase from line to line.
      Set this option to 1 to make aligned trailing multiline comments not
      create indentation.
    '';

    showFirstIndentLevel =
      helpers.defaultNullOpts.mkBool true "Displays indentation in the first column.";

    showTrailingBlanklineIndent = helpers.defaultNullOpts.mkBool true ''
      Displays a trailing indentation guide on blank lines, to match the
      indentation of surrounding code.
      Turn this off if you want to use background highlighting instead of chars.
    '';

    showEndOfLine = helpers.defaultNullOpts.mkBool false ''
      Displays the end of line character set by |listchars| instead of the
      indent guide on line returns.
    '';

    showFoldtext = helpers.defaultNullOpts.mkBool true ''
      Displays the full fold text instead of the indent guide on folded lines.

      Note: there is no autocommand to subscribe to changes in folding. This
            might lead to unexpected results. A possible solution for this is to
            remap folding bindings to also call |IndentBlanklineRefresh|
    '';

    disableWithNolist = helpers.defaultNullOpts.mkBool false ''
      When true, automatically turns this plugin off when |nolist| is set.
      When false, setting |nolist| will keep displaying indentation guides but
      removes whitespace characters set by |listchars|.
    '';

    filetype = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" ''
      Specifies a list of |filetype| values for which this plugin is enabled.
      All |filetypes| are enabled if the value is an empty list.
    '';

    filetypeExclude =
      helpers.defaultNullOpts.mkNullable (types.listOf types.str)
      ''["lspinfo" "packer" "checkhealth" "help" "man" ""]'' ''
        Specifies a list of |filetype| values for which this plugin is not enabled.
        Ignored if the value is an empty list.
      '';

    buftypeExclude =
      helpers.defaultNullOpts.mkNullable (types.listOf types.str)
      ''["terminal" "nofile" "quickfix" "prompt"]'' ''
        Specifies a list of |buftype| values for which this plugin is not enabled.
        Ignored if the value is an empty list.
      '';

    bufnameExclude = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" ''
      Specifies a list of buffer names (file name with full path) for which
      this plugin is not enabled.
      A name can be regular expression as well.
    '';

    strictTabs = helpers.defaultNullOpts.mkBool false ''
      When on, if there is a single tab in a line, only tabs are used to
      calculate the indentation level.
      When off, both spaces and tabs are used to calculate the indentation
      level.
      Only makes a difference if a line has a mix of tabs and spaces for
      indentation.
    '';

    showCurrentContext = helpers.defaultNullOpts.mkBool false ''
      When on, use treesitter to determine the current context. Then show the
      indent character in a different highlight.

      Note: Requires https://github.com/nvim-treesitter/nvim-treesitter to be
            installed

      Note: With this option enabled, the plugin refreshes on |CursorMoved|,
            which might be slower
    '';

    showCurrentContextStart = helpers.defaultNullOpts.mkBool false ''
      Applies the |hl-IndentBlanklineContextStart| highlight group to the first
      line of the current context.
      By default this will underline.

      Note: Requires https://github.com/nvim-treesitter/nvim-treesitter to be
            installed

      Note: You need to have set |gui-colors| and it depends on your terminal
            emulator if this works as expected.
            If you are using kitty and tmux, take a look at this article to
            make it work
            http://evantravers.com/articles/2021/02/05/curly-underlines-in-kitty-tmux-neovim/
    '';

    showCurrentContextStartOnCurrentLine = helpers.defaultNullOpts.mkBool true ''
      Shows showCurrentContextStart even when the cursor is on the same line
    '';

    contextChar = helpers.defaultNullOpts.mkStr config.plugins.indent-blankline.char ''
      Specifies the character to be used for the current context indent line.
      Not used if contextCharList is not empty.

      Useful to have a greater distinction between the current context indent
      line and others.

      Also useful in combination with char set to empty string
      (""), as this allows only the current context indent line to be shown.
    '';

    contextCharBlankline = helpers.defaultNullOpts.mkStr "" ''
      Equivalent of charBlankline for contextChar.
    '';

    contextCharList = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" ''
      Equivalent of charList for contextChar.
    '';

    contextCharListBlankline = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" ''
      Equivalent of charListBlankline for contextChar.
    '';

    contextHighlightList = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" ''
      Specifies the list of character highlights for the current context at
      each indentation level.
      Ignored if the value is an empty list.
    '';

    charPriority = helpers.defaultNullOpts.mkInt 1 "Specifies the |extmarks| priority for chars.";

    contextStartPriority =
      helpers.defaultNullOpts.mkInt 10000
      "Specifies the |extmarks| priority for the context start.";

    contextPatterns = helpers.defaultNullOpts.mkNullable (types.listOf types.str) ''
      [
        "class"
        "^func"
        "method"
        "^if"
        "while"
        "for"
        "with"
        "try"
        "except"
        "arguments"
        "argument_list"
        "object"
        "dictionary"
        "element"
        "table"
        "tuple"
        "do_block"
      ]'' ''
      Specifies a list of lua patterns that are used to match against the
      treesitter |tsnode:type()| at the cursor position to find the current
      context.

      To learn more about how lua pattern work, see here:
      https://www.lua.org/manual/5.1/manual.html#5.4.1

    '';

    useTreesitterScope = helpers.defaultNullOpts.mkBool false ''
      Instead of using contextPatters use the current scope defined by nvim-treesitter as the
      context
    '';

    contextPatternHighlight = helpers.defaultNullOpts.mkNullable (types.attrsOf types.str) "{}" ''
      Specifies a map of patterns set in contextPatterns to highlight groups.
      When the current matching context pattern is in the map, the context
      will be highlighted with the corresponding highlight group.
    '';

    viewportBuffer = helpers.defaultNullOpts.mkInt 10 ''
      Sets the buffer of extra lines before and after the current viewport that
      are considered when generating indentation and the context.
    '';

    disableWarningMessage =
      helpers.defaultNullOpts.mkBool false "Turns deprecation warning messages off.";

    extraOptions = mkOption {
      type = types.attrs;
      default = {};
      description = ''
        Extra configuration options for indent-blankline without the 'indent_blankline_' prefix.
        Example: To set 'indent_blankline_foobar' to 1, write
        ```nix
          extraConfig = {
            foobar = true;
          };
        ```
      '';
    };
  };

  config = let
    cfg = config.plugins.indent-blankline;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      globals =
        mapAttrs'
        (name: nameValuePair ("indent_blankline_" + name))
        (
          {
            inherit (cfg) char;
            char_blankline = cfg.charBlankline;
            char_list = cfg.charList;
            char_list_blankline = cfg.charListBlankline;
            char_highlight_list = cfg.charHighlightList;
            space_char_blankline = cfg.spaceCharBlankline;
            space_char_highlight_list = cfg.spaceCharHighlightList;
            space_char_blankline_highlight_list = cfg.spaceCharBlanklineHighlightList;
            use_treesitter = cfg.useTreesitter;
            indent_level = cfg.indentLevel;
            max_indent_increase = cfg.maxIndentIncrease;
            show_first_indent_level = cfg.showFirstIndentLevel;
            show_trailing_blankline_indent = cfg.showTrailingBlanklineIndent;
            show_end_of_line = cfg.showEndOfLine;
            show_foldtext = cfg.showFoldtext;
            disable_with_nolist = cfg.disableWithNolist;
            inherit (cfg) filetype;
            filetype_exclude = cfg.filetypeExclude;
            buftype_exclude = cfg.buftypeExclude;
            bufname_exclude = cfg.bufnameExclude;
            strict_tabs = cfg.strictTabs;
            show_current_context = cfg.showCurrentContext;
            show_current_context_start = cfg.showCurrentContextStart;
            show_current_context_start_on_current_line = cfg.showCurrentContextStartOnCurrentLine;
            context_char = cfg.contextChar;
            context_char_blankline = cfg.contextCharBlankline;
            context_char_list = cfg.contextCharList;
            context_char_list_blankline = cfg.contextCharListBlankline;
            context_highlight_list = cfg.contextHighlightList;
            char_priority = cfg.charPriority;
            context_start_priority = cfg.contextStartPriority;
            context_patterns = cfg.contextPatterns;
            use_treesitter_scope = cfg.useTreesitterScope;
            context_pattern_highlight = cfg.contextPatternHighlight;
            viewport_buffer = cfg.viewportBuffer;
            disable_warning_message = cfg.disableWarningMessage;
          }
          // cfg.extraOptions
        );
    };
}
