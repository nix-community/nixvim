{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts mkNullOrStr mkNullOrOption;
  inherit (lib) types;
in
lib.nixvim.plugins.mkVimPlugin {
  name = "scrollview";
  packPathName = "nvim-scrollview";
  package = "nvim-scrollview";
  globalPrefix = "scrollview_";
  description = "A Neovim plugin that displays interactive vertical scrollbars and signs.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions =
    let
      mkPriorityOption =
        name: default:
        defaultNullOpts.mkUnsignedInt default ''
          The priority for the ${name}.

          Considered only when the plugin is loaded.
        '';

      symbolCommonDesc = ''
        A list of strings can also be used; the symbol is selected using the index equal to the
        number of lines corresponding to the sign, or the last element when the retrieval would be
        out-of-bounds.

        Considered only when the plugin is loaded.
      '';

      symbolType = with types; maybeRaw (either str (listOf (maybeRaw str)));
    in
    {
      always_show = defaultNullOpts.mkBool false ''
        Specify whether scrollbars and signs are shown when all lines are visible.
      '';

      base =
        defaultNullOpts.mkEnumFirstDefault
          [
            "right"
            "left"
            "buffer"
          ]
          ''
            Specify where the scrollbar is anchored.

            Possible values are `"left"` or `"right"` for corresponding window edges, or `"buffer"`.
          '';

      byte_limit = defaultNullOpts.mkInt 1000000 ''
        The buffer size threshold (in bytes) for entering restricted mode, to prevent slow operation.

        Use `-1` for no limit.
      '';

      character = defaultNullOpts.mkStr "" ''
        A character to display on scrollbars.

        Scrollbar transparency (via `|scrollview_winblend|`) is not possible when a scrollbar
        character is used.
      '';

      column = defaultNullOpts.mkPositiveInt 1 ''
        The scrollbar column (relative to `|scrollview_base|`).

        Must be an integer greater than or equal to `1`.
      '';

      consider_border = defaultNullOpts.mkBool false ''
        (experimental)

        Specify whether floating window borders are taken into account for positioning scrollbars and
        signs.
        - When set to `true`, borders are considered as part of the window; scrollbars and signs can
          be positioned where there are borders.
        - When set to `false`, borders are ignored.

        The setting is only applicable for floating windows that have borders, and only relevant when
        `floating_windows` is turned on and `base` is set to `"left"` or `"right"`.
      '';

      current_only = defaultNullOpts.mkBool false ''
        Whether scrollbars and signs should only be displayed in the current window.
      '';

      excluded_filetypes = defaultNullOpts.mkListOf types.str [ ] ''
        optional file types for which scrollbars should not be displayed.
      '';

      floating_windows = defaultNullOpts.mkBool false ''
        Whether scrollbars and signs are shown in floating windows.
      '';

      hide_bar_for_insert = defaultNullOpts.mkBool false ''
        Whether the scrollbar is hidden in the current window for insert mode.

        See the `signs_hidden_for_insert` option for hiding signs.
      '';

      hide_on_intersect = defaultNullOpts.mkBool false ''
        Whether each scrollbar or sign becomes hidden (not shown) when it would otherwise intersect
        with a floating window.
      '';

      hover = defaultNullOpts.mkBool true ''
        Whether the highlighting of scrollbars and signs should change when hovering with the mouse.
        Requires mouse support (see `|'mouse'|`) with `|'mousemoveevent'|` set.
      '';

      include_end_region = defaultNullOpts.mkBool false ''
        Whether the region beyond the last line is considered as containing ordinary lines for the
        calculation of scrollbar height and positioning.
      '';

      line_limit = defaultNullOpts.mkInt (-1) ''
        The buffer size threshold (in lines) for entering restricted mode, to prevent slow operation.
        Defaults to `20000`.
        Use `-1` for no limit.
      '';

      mode = defaultNullOpts.mkStr "auto" ''
        Specify what the scrollbar position and size correspond to.
        See |scrollview-modes| for details on the available modes.
      '';

      mouse_primary = defaultNullOpts.mkStr "left" ''
        The button for primary mouse operations (dragging scrollbars and clicking signs).

        Possible values include `"left"`, `"middle"`, `"right"`, `"x1"`, and `"x2"`.
        These can be prepended with `"c-"` or `"m-"` for the control-key and alt-key variants
        (e.g., `"c-left"` for control-left).

        An existing mapping will not be clobbered, unless `"!"` is added at the end (e.g., `"left!"`).
        Set to `"nil"` to disable the functionality.

        Considered only when the plugin is loaded.
      '';

      mouse_secondary = defaultNullOpts.mkStr "right" ''
        The button for secondary mouse operations (clicking signs for additional information).

        See the `mouse_primary` option for the possible values, including how `"c-"`, `"m-"`, `"!"`,
        and `"nil"` can be utilized.

        Considered only when the plugin is loaded.
      '';

      on_startup = defaultNullOpts.mkBool true ''
        Whether scrollbars are enabled on startup.

        Considered only when the plugin is loaded.
      '';

      winblend = defaultNullOpts.mkUnsignedInt 50 ''
        The level of transparency for scrollbars when a GUI is not running and `termguicolors` is not
        set.

        Must be between `0` (opaque) and `100` (transparent).

        This option is ignored for scrollview windows whose highlight group has `reverse` or `inverse`
        specified as a cterm attribute; see `|attr-list|`.
        Such windows will have no transparency, as a workaround for Neovim #24159.

        This option is ignored for scrollview windows shown for floating windows; see
        `|scrollview_floating_windows|`.
        Such windows will have no transparency, as a workaround for Neovim #14624.
      '';

      winblend_gui = defaultNullOpts.mkUnsignedInt 0 ''
        (experimental)

        The level of transparency for scrollbars when a GUI is running or `termguicolors` is set.

        Must be between `0` (opaque) and `100` (transparent).

        This option is ignored for scrollview windows whose highlight group has `reverse` or `inverse`
        specified as a gui attribute; see `|attr-list|`.
        Such windows will have no transparency, as a workaround for Neovim #24159.

        This option is ignored for scrollview windows shown for floating windows; see
        `|scrollview_floating_windows|`.
        Such windows will have no transparency, as a workaround for Neovim #14624.

        This option can interact with highlight settings (`|scrollview-color-customization|`); careful
        adjustment of the winblend setting and highlighting may be necessary to achieve the desired
        result.
      '';

      zindex = defaultNullOpts.mkUnsignedInt 40 ''
        The z-index for scrollbars and signs.
        Must be larger than zero.
      '';

      signs_hidden_for_insert = defaultNullOpts.mkListOf types.str [ ] ''
        The sign groups to hide in the current window for insert mode.
        Set to `[ "all" ]` to hide all sign groups.

        See `|scrollview_hide_bar_for_insert|` for hiding the scrollbar.
      '';

      signs_max_per_row = defaultNullOpts.mkInt (-1) ''
        The maximum number of signs per row.
        Set to `-1` to have no limit.
      '';

      signs_on_startup =
        defaultNullOpts.mkListOf types.str
          [
            "diagnostics"
            "marks"
            "search"
          ]
          ''
            The built-in sign groups to enable on startup.
            Set to `{__empty = null;}` to disable all built-in sign groups on startup.
            Set to `['all']` to enable all sign groups.
            Considered only when the plugin is loaded.
          '';

      signs_overflow =
        defaultNullOpts.mkEnumFirstDefault
          [
            "left"
            "right"
          ]
          ''
            The sign overflow direction (to avoid overlapping the scrollbar or other signs).
          '';

      signs_show_in_folds = defaultNullOpts.mkBool false ''
        Whether signs on lines within hidden folds should be shown.
        Sign groups can override this setting (e.g., the built-in cursor sign group does).
      '';

      changelist_previous_priority = mkPriorityOption "the previous item changelist sign" 15;

      changelist_previous_symbol = mkNullOrStr ''
        The symbol for the previous item changelist sign.

        Defaults to an upwards arrow with tip leftwards.
      '';

      changelist_current_priority = mkPriorityOption "the current changelist sign" 10;

      changelist_current_symbol = defaultNullOpts.mkStr "@" ''
        The symbol for the current item changelist sign.
      '';

      changelist_next_priority = mkPriorityOption "the next item changelist sign" 5;

      changelist_next_symbol = mkNullOrStr ''
        The symbol for the next item changelist sign.

        Defaults to a downwards arrow with tip rightwards.
      '';

      conflicts_bottom_priority = mkPriorityOption "conflict bottom signs" 80;

      conflicts_bottom_symbol = defaultNullOpts.mkNullable symbolType ">" ''
        The symbol for conflict bottom signs.

        ${symbolCommonDesc}
      '';

      conflicts_middle_priority = mkPriorityOption "conflict middle signs" 75;

      conflicts_middle_symbol = defaultNullOpts.mkNullable symbolType "=" ''
        The symbol for conflict middle signs.

        ${symbolCommonDesc}
      '';

      conflicts_top_priority = mkPriorityOption "conflict top signs" 70;

      conflicts_top_symbol = defaultNullOpts.mkNullable symbolType "<" ''
        The symbol for conflict top signs.

        ${symbolCommonDesc}
      '';

      cursor_priority = mkPriorityOption "cursor signs" 0;

      cursor_symbol = mkNullOrStr ''
        The symbol for cursor signs.

        Defaults to a small square, resembling a block cursor.
      '';

      diagnostics_error_priority = mkPriorityOption "cursor diagnostic error signs" 60;

      diagnostics_error_symbol = mkNullOrOption symbolType ''
        The symbol for diagnostic error signs.

        Defaults to the trimmed sign text for `DiagnosticSignError` if defined, or `"E"` otherwise.

        ${symbolCommonDesc}
      '';

      diagnostics_hint_priority = mkPriorityOption "the diagnostic hint signs" 30;

      diagnostics_hint_symbol = mkNullOrOption symbolType ''
        The symbol for diagnostic hint signs.

        Defaults to the trimmed sign text for `DiagnosticSignHint` if defined, or `"H"` otherwise.

        ${symbolCommonDesc}
      '';

      diagnostics_info_priority = mkPriorityOption "the diagnostic info signs" 40;

      diagnostics_info_symbol = mkNullOrOption symbolType ''
        The symbol for diagnostic info signs.

        Defaults to the trimmed sign text for `DiagnosticSignInfo` if defined, or `"I"` otherwise.

        ${symbolCommonDesc}
      '';

      diagnostics_severities =
        mkNullOrOption (with types; maybeRaw (either ints.unsigned (listOf (maybeRaw ints.unsigned))))
          ''
            List of numbers specifying the diagnostic severities for which signs will be shown.
            The default includes `vim.diagnostic.severity.ERROR`, `vim.diagnostic.severity.HINT`,
            `"vim.diagnostic.severity.INFO"`, and `vim.diagnostic.severity.WARN`.

            Considered only when the plugin is loaded.
          '';

      diagnostics_warn_priority = mkPriorityOption "the diagnostic warn signs" 50;

      diagnostics_warn_symbol = mkNullOrOption symbolType ''
        The symbol for diagnostic warn signs.

        Defaults to the trimmed sign text for `DiagnosticSignWarn` if defined, or `"W"` otherwise.

        ${symbolCommonDesc}
      '';

      folds_priority = mkPriorityOption "fold signs" 30;

      folds_symbol = mkNullOrOption symbolType ''
        The symbol for fold signs.

        Defaults to a right-pointing triangle.

        ${symbolCommonDesc}
      '';

      latestchange_priority = mkPriorityOption "latestchange signs" 10;

      latestchange_symbol = mkNullOrStr ''
        The symbol for latestchange signs.

        Defaults to a Greek uppercase delta.
      '';

      loclist_priority = mkPriorityOption "loclist signs" 45;

      loclist_symbol = mkNullOrOption symbolType ''
        The symbol for loclist signs.

        Defaults to a small circle.

        ${symbolCommonDesc}
      '';

      marks_characters = defaultNullOpts.mkListOf' {
        type = types.str;
        description = ''
          List of strings specifying characters for which mark signs will be shown.
          Defaults to characters `a-z` and `A-Z`.

          Considered only when the plugin is loaded.
        '';
      };

      marks_priority = mkPriorityOption "mark signs" 50;

      quickfix_priority = mkPriorityOption "quickfix signs" 45;

      quickfix_symbol = mkNullOrOption symbolType ''
        The symbol for quickfix signs.

        Defaults to a small circle.

        ${symbolCommonDesc}
      '';

      search_priority = mkPriorityOption "search signs" 70;

      search_symbol = mkNullOrOption symbolType ''
        The symbol for search signs.

        Defaults to `["=" "=" {__raw = "vim.fn.nr2char(0x2261)";}]` where the third element is the triple
        bar.

        ${symbolCommonDesc}
      '';

      spell_priority = mkPriorityOption "spell signs" 20;

      spell_symbol = defaultNullOpts.mkNullable symbolType "~" ''
        The symbol for spell signs.

        ${symbolCommonDesc}
      '';

      textwidth_priority = mkPriorityOption "textwidth signs" 20;

      textwidth_symbol = mkNullOrOption symbolType ''
        The symbol for textwidth signs.

        Defaults to a right-pointing double angle quotation mark.

        ${symbolCommonDesc}
      '';

      trail_priority = mkPriorityOption "trail signs" 50;

      trail_symbol = mkNullOrOption symbolType ''
        The symbol for trail signs.

        Defaults to an outlined square.

        ${symbolCommonDesc}
      '';
    };

  settingsExample = {
    excluded_filetypes = [ "nerdtree" ];
    current_only = true;
    base = "buffer";
    column = 80;
    signs_on_startup = [ "all" ];
    diagnostics_severities = [ { __raw = "vim.diagnostic.severity.ERROR"; } ];
  };
}
