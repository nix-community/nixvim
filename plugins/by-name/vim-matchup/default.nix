{
  lib,
  config,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts mkNullOrStr';
  inherit (lib) types;
in
lib.nixvim.plugins.mkVimPlugin {
  name = "vim-matchup";
  globalPrefix = "matchup_";
  description = "`match-up` is a plugin that lets you highlight, navigate, and operate on sets of matching text.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  extraOptions = {
    treesitter = lib.nixvim.mkSettingsOption {
      description = ''
        Options provided to the treesitter matchup integration.
      '';
      options = {
        enable = lib.mkEnableOption "treesitter integration";

        disable = defaultNullOpts.mkListOf types.str [ ] ''
          Languages for which to disable this module.
        '';

        disable_virtual_text = defaultNullOpts.mkBool false ''
          Do not use virtual text to highlight the virtual end of a block, for languages without
          explicit end markers (e.g., Python).
        '';

        include_match_words = defaultNullOpts.mkBool false ''
          Additionally include traditional vim regex matches for symbols.
          For example, highlights `/* */` comments in C++ which are not supported in tree-sitter
          matching.
        '';
      };
      example = {
        enable = true;
        disable = [
          "c"
          "ruby"
        ];
      };
    };
  };

  extraConfig = cfg: {
    warnings = lib.nixvim.mkWarnings "plugins.vim-matchup" {
      when = cfg.treesitter.enable && (!config.plugins.treesitter.enable);

      message = ''
        `plugins.vim-matchup.treesitter.enable` is `true`, but the treesitter plugin itself is not.
        -> Set `plugins.treesitter.enable` to `true`.
      '';
    };

    plugins.treesitter.settings.matchup = cfg.treesitter;
  };

  settingsOptions = {
    enabled = defaultNullOpts.mkFlagInt 1 ''
      Set to `0` to disable the plugin entirely.
    '';

    mappings_enabled = defaultNullOpts.mkFlagInt 1 ''
      Set to `0` to disable all mappings.
    '';

    mouse_enabled = defaultNullOpts.mkFlagInt 1 ''
      Set to `0` to disable selecting matches with double click.
    '';

    motion_enabled = defaultNullOpts.mkFlagInt 1 ''
      Set to `0` to disable motions (`|matchup-%|`, `|%|`, `|[%|`, `|]%|`).
    '';

    text_obj_enabled = defaultNullOpts.mkFlagInt 1 ''
      Set to `0` to disable text objects (`|a%|`, `|i%|`).
    '';

    transmute_enabled = defaultNullOpts.mkFlagInt 0 ''
      Set to 1 to enable the experimental transmute feature (`|matchup-transmute|`).
    '';

    delim_stopline = defaultNullOpts.mkUnsignedInt 1500 ''
      Configures the number of lines to search in either direction while using motions and text
      objects.
      Does not apply to match highlighting (see `matchparen_stopline` instead).
    '';

    delim_noskips = defaultNullOpts.mkEnumFirstDefault [ 0 1 2 ] ''
      This option controls whether matching is done within strings and comments.

      - By default, it is set to `0` which means all valid matches are made within strings and
        comments.
      - If set to `1`, symbols like `()` will still be matched but words like `for` and `end` will
        not.
      - If set to `2`, nothing will be matched within strings and comments.
    '';

    delim_nomids = defaultNullOpts.mkFlagInt 0 ''
      If set to `1`, middle words (like `return`) are not matched to start and end words for
      highlighting and motions.
    '';

    delim_start_plaintext = defaultNullOpts.mkFlagInt 1 ''
      When enabled (the default), the plugin will be loaded for all buffers, including ones without
      a file type set.

      This allows matching to be done in new buffers and plain text files but adds a small start-up
      cost to vim.
    '';

    matchparen_enabled = defaultNullOpts.mkFlagInt 1 ''
      This option can disable match highlighting at `|startup|`.

      Note: vim's built-in plugin `|pi_paren|` plugin is also disabled.
      The variable `g:loaded_matchparen` has no effect on match-up.

      You can also enable and disable highlighting for specific buffers using the variable
      `|b:matchup_matchparen_enabled|`.
    '';

    matchparen_singleton = defaultNullOpts.mkFlagInt 0 ''
      Whether or not to highlight recognized words even if there is no match.
    '';

    matchparen_offscreen = defaultNullOpts.mkNullable' {
      pluginDefault = {
        method = "status";
      };
      description = ''
        Attrs controlling the behavior with off-screen matches.
        If empty, this feature is disabled.
      '';
      type = types.submodule {
        freeformType = with types; attrsOf anything;
        options = {
          method = defaultNullOpts.mkNullable' {
            pluginDefault = "status";
            type = types.enum [
              "status"
              "status_manual"
              "popup"
            ];
            example = "popup";
            description = ''
              Sets the method to use to show off-screen matches.
              Possible values are:

              - `"status"` (default): Replace the |status-line| for off-screen matches.\
                If a match is off of the screen, the line belonging to that match will be displayed
                syntax-highlighted in the status line along with the line number (if line numbers
                are enabled).
                If the match is above the screen border, an additional `Δ` symbol will be shown to
                indicate that the matching line is really above the cursor line.
              - `"status_manual"`: Compute the string which would be displayed in the status-line or
                popup, but do not display it.
                The function `MatchupStatusOffscreen()` can be used to get the text.
              - `"popup"`: Use a floating window to show the off-screen match.
            '';
          };

          scrolloff = defaultNullOpts.mkFlagInt 0 ''
            When enabled, off-screen matches will not be shown in the statusline while the cursor is
            at the screen edge (respects the value of `'scrolloff'`).

            This is intended to prevent flickering while scrolling with `j` and `k`.
          '';

          fullwidth = defaultNullOpts.mkFlagInt 0 ''
            For `"popup"` method: make the floating window as wide as the current window.
          '';

          highlight = mkNullOrStr' {
            description = ''
              For popup method on vim only: set to a highlight group to override the colors in the
              popup window.
              The default is to use `*hl-Pmenu*`.
            '';
            example = "OffscreenPopup";
          };

          syntax_hl = defaultNullOpts.mkFlagInt 0 ''
            For popup method on vim only: syntax highlight the code in the popup.
            May have performance implications.
          '';

          border = defaultNullOpts.mkNullable (with types; either intFlag (listOf str)) 0 ''
            For floating window on neovim only: set to add a border.
            If the value is the integer `1`, default borders are enabled.

            A list or string can be specified as described in `|nvim_open_win()|`.
          '';
        };
      };
      example.__empty = null;
    };

    matchparen_stopline = defaultNullOpts.mkUnsignedInt 400 ''
      The number of lines to search in either direction while highlighting matches.

      Set this conservatively since high values may cause performance issues.
    '';

    matchparen_timeout = defaultNullOpts.mkUnsignedInt 300 ''
      Adjust the timeouts in milliseconds for highlighting.
    '';

    matchparen_insert_timeout = defaultNullOpts.mkUnsignedInt 60 ''
      Adjust the timeouts in milliseconds for highlighting.
    '';

    matchparen_deferred = defaultNullOpts.mkFlagInt 0 ''
      Deferred highlighting improves cursor movement performance (for example, when using `|hjkl|`)
      by delaying highlighting for a short time and waiting to see if the cursor continues moving.
    '';

    matchparen_deferred_show_delay = defaultNullOpts.mkUnsignedInt 50 ''
      Delay, in milliseconds, between when the cursor moves and when we start checking if the cursor
      is on a match.

      Applies to both making highlights and clearing them for deferred highlighting.
    '';

    matchparen_deferred_hide_delay = defaultNullOpts.mkUnsignedInt 700 ''
      If the cursor has not stopped moving, assume highlight is stale after this many milliseconds.

      Stale highlights are hidden.
    '';

    matchparen_deferred_fade_time = defaultNullOpts.mkUnsignedInt 0 ''
      When set to `{time}` in milliseconds, the deferred highlighting behavior is changed in two
      ways:

      1. Highlighting of matches is preserved for at least `{time}` even when the cursor is moved
        away.
      2. If the cursor stays on the same match for longer than `{time}`, highlighting is cleared.

      The effect is that highlighting occurs momentarily and then disappears, regardless of where
      the cursor is.
      It is possible that fading takes longer than `{time}`, if vim is busy doing other things.

      This value should be greater than the deferred show delay.
    '';

    matchparen_pumvisible = defaultNullOpts.mkFlagInt 1 ''
      If set to `1`, matches will be made even when the `|popupmenu-completion|` is visible.

      If you use an auto-complete plugin which interacts badly with matching, set this option to
      `0`.
    '';

    matchparen_nomode = defaultNullOpts.mkStr' {
      pluginDefault = "";
      example = "vV\<c-v>";
      description = ''
        When not empty, match highlighting will be disabled in the specified modes, where each mode
        is a single character like in the `|mode()|` function.

        E.g., to disable highlighting in insert mode,
        ```nix
        matchparen_nomode = "i";
        ```
        and in visual modes,
        ```nix
        matchparen_nomode = "vV\<c-v>";
        ```

        Note: In visual modes, this takes effect only after moving the cursor.
      '';
    };

    matchparen_hi_surround_always = defaultNullOpts.mkFlagInt 0 ''
      Always highlight the surrounding words, if possible.
      This is like `|<plug>(matchup-hi-surround)|` but is updated each time the cursor moves.

      This requires deferred matching (`matchparen_deferred = 1`).
    '';

    matchparen_hi_background = defaultNullOpts.mkFlagInt 0 ''
      Highlight buffer background between matches.
      This uses the `MatchBackground` highlighting group and is linked to `ColorColumn` by default.
    '';

    matchparen_end_sign = defaultNullOpts.mkStr "◀" ''
      Configure the virtual symbol shown for closeless matches in languages like C++ and python.

      ```cpp
      if (true)
        cout << "";
      else
        cout << ""; ◀ if
      ```
    '';

    motion_override_Npercent = defaultNullOpts.mkUnsignedInt 6 ''
      In vim, `{count}%` goes to the `{count}` percentage in the file (see `|N%|`).
      match-up overrides this motion for small `{count}` (by default, anything less than 7).

      - For example, to allow `{count}%` for `{count}` less than 12, set it to `11`.
      - To disable this feature, and restore vim's default `{count}%`, set it to `0`.
      - To always enable this feature, use any value greater than 99.
    '';

    motion_cursor_end = defaultNullOpts.mkFlagInt 1 ''
      If enabled, cursor will land on the end of mid and close words while moving downwards
      (`|%|/|]%|`).
      While moving upwards (`|g%|`, `|[%|`) the cursor will land on the beginning.
      Set to `0` to disable.

      Note: this has no effect on operators: `d%` will delete `|inclusive|` of the ending word (this
      is compatible with matchit).
    '';

    delim_count_fail = defaultNullOpts.mkFlagInt 0 ''
      When disabled (default), giving an invalid count to the `|[%|` and `|]%|` motions and the text
      objects `|i%|` and `|a%|` will cause the motion or operation to fail.

      When enabled, they will move as far as possible.

      Note: targeting high counts when this option is enabled can become slow because many positions
      need to be tried before giving up.
    '';

    text_obj_linewise_operators = defaultNullOpts.mkListOf types.str [ "d" "y" ] ''
      Modifies the set of operators which may operate line-wise with `|i%|` (see
      `|matchup-feat-linewise|`).

      You may use `"v"`, `"V"`, and `"\<c-v>"` (i.e., an actual CTRL-V character) to specify the
      corresponding visual mode.

      You can also specify custom plugin operators with 'g@' and optionally, an expression separated
      by a comma.
    '';

    surround_enabled = defaultNullOpts.mkFlagInt 0 ''
      Enables the surround module which provides maps `|ds%|` and `|cs%|`.
    '';

    override_vimtex = defaultNullOpts.mkFlagInt 0 ''
      By default, match-up is disabled for tex files when the plugin `|vimtex|` is detected.

      To enable match-up for tex files, set this option to `1`.
      This will replace vimtex's built-in highlighting and `%` map.

      Note: matching may be computationally intensive for complex LaTeX documents.
      If you experience slowdowns, consider also setting `matchparen_deferred` to `1`.
    '';
  };

  settingsExample = {
    mouse_enabled = 0;
    surround_enabled = 1;
    transmute_enabled = 1;
    matchparen_offscreen.method = "popup";
  };
}
