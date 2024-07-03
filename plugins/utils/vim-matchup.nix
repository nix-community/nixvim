{
  lib,
  helpers,
  pkgs,
  config,
  ...
}:
with lib;
{
  options.plugins.vim-matchup = {
    enable = mkEnableOption "vim-matchup";

    package = helpers.mkPluginPackageOption "vim-matchup" pkgs.vimPlugins.vim-matchup;

    treesitterIntegration = {
      enable = mkEnableOption "treesitter integration";
      disable =
        helpers.defaultNullOpts.mkListOf types.str [ ]
          "Languages for each to disable this module";

      disableVirtualText = helpers.defaultNullOpts.mkBool false ''
        Do not use virtual text to highlight the virtual end of a block, for languages without
        explicit end markers (e.g., Python).
      '';
      includeMatchWords = helpers.defaultNullOpts.mkBool false ''
        Additionally include traditional vim regex matches for symbols. For example, highlights
        `/* */` comments in C++ which are not supported in tree-sitter matching
      '';
    };

    matchParen = {
      enable = helpers.defaultNullOpts.mkBool true "Control matching parentheses";

      fallback = helpers.defaultNullOpts.mkBool true ''
        If matchParen is not enabled fallback to the standard vim matchparen.
      '';

      singleton = helpers.defaultNullOpts.mkBool false "Whether to highlight known words even if there is no match";

      offscreen = helpers.defaultNullOpts.mkNullable (types.submodule {
        options = {
          method =
            helpers.defaultNullOpts.mkEnumFirstDefault
              [
                "status"
                "popup"
                "status_manual"
              ]
              ''
                'status': Replace the status-line for off-screen matches.

                If a match is off of the screen, the line belonging to that match will be displayed
                syntax-highlighted in the status line along with the line number (if line numbers
                are enabled). If the match is above the screen border, an additional Δ symbol will
                be shown to indicate that the matching line is really above the cursor line.

                'popup': Show off-screen matches in a popup (vim) or floating (neovim) window.

                'status_manual': Compute the string which would be displayed in the status-line or
                popup, but do not display it. The function MatchupStatusOffscreen() can be used to
                get the text.
              '';
          scrolloff = helpers.defaultNullOpts.mkBool false ''
            When enabled, off-screen matches will not be shown in the statusline while the
            cursor is at the screen edge (respects the value of 'scrolloff').
            This is intended to prevent flickering while scrolling with j and k.
          '';
        };
      }) { method = "status"; } "Dictionary controlling the behavior with off-screen matches.";

      stopline = helpers.defaultNullOpts.mkInt 400 ''
        The number of lines to search in either direction while highlighting matches.
        Set this conservatively since high values may cause performance issues.
      '';

      timeout =
        helpers.defaultNullOpts.mkInt 300
          "Adjust timeouts in milliseconds for matchparen highlighting";

      insertTimeout =
        helpers.defaultNullOpts.mkInt 60
          "Adjust timeouts in milliseconds for matchparen highlighting";

      deferred = {
        enable = helpers.defaultNullOpts.mkBool false ''
          Deferred highlighting improves cursor movement performance (for example, when using hjkl)
          by delaying highlighting for a short time and waiting to see if the cursor continues
          moving
        '';

        showDelay = helpers.defaultNullOpts.mkInt 50 ''
          Adjust delays in milliseconds for deferred highlighting
        '';

        hideDelay = helpers.defaultNullOpts.mkInt 700 ''
          Adjust delays in milliseconds for deferred highlighting
        '';
      };

      hiSurroundAlways = helpers.defaultNullOpts.mkBool false ''
        Highlight surrounding delimiters always as the cursor moves
        Note: this feature requires deferred highlighting to be supported and enabled.
      '';
    };

    motion = {
      enable = helpers.defaultNullOpts.mkBool true "Control motions";
      overrideNPercent = helpers.defaultNullOpts.mkInt 6 ''
        In vim, {count}% goes to the {count} percentage in the file. match-up overrides this
        motion for small {count} (by default, anything less than 7). To allow {count}% for {count}
        less than 12 set overrideNPercent to 11.

        To disable this feature set it to 0.

        To always enable this feature, use any value greater than 99
      '';
      cursorEnd = helpers.defaultNullOpts.mkBool true ''
        If enabled, cursor will land on the end of mid and close words while moving downwards
        (%/]%). While moving upwards (g%, [%) the cursor will land on the beginning.
      '';
    };

    textObj = {
      enable = helpers.defaultNullOpts.mkBool true "Controls text objects";

      linewiseOperators = helpers.defaultNullOpts.mkListOf types.str [
        "d"
        "y"
      ] "Modify the set of operators which may operate line-wise";
    };

    enableSurround = helpers.defaultNullOpts.mkBool false "To enable the delete surrounding (ds%) and change surrounding (cs%) maps";

    enableTransmute = helpers.defaultNullOpts.mkBool false "To enable the experimental transmute module";

    delimStopline = helpers.defaultNullOpts.mkInt 1500 ''
      To configure the number of lines to search in either direction while using motions and text
      objects. Does not apply to match highlighting (see matchParenStopline instead)
    '';

    delimNoSkips =
      helpers.defaultNullOpts.mkEnumFirstDefault
        [
          0
          1
          2
        ]
        ''
          To disable matching within strings and comments:
          - 0: matching is enabled within strings and comments
          - 1: recognize symbols within comments
          - 2: don't recognize anything in comments
        '';
  };

  # TODO introduced 2024-03-07: remove 2024-05-07
  imports = [
    (mkRenamedOptionModule
      [
        "plugins"
        "vim-matchup"
        "matchParen"
        "deffered"
      ]
      [
        "plugins"
        "vim-matchup"
        "matchParen"
        "deferred"
      ]
    )
  ];

  config =
    let
      cfg = config.plugins.vim-matchup;
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      plugins.treesitter.settings.matchup = mkIf cfg.treesitterIntegration.enable {
        inherit (cfg.treesitterIntegration) enable disable;
        disable_virtual_text = cfg.treesitterIntegration.disableVirtualText;
        include_match_words = cfg.treesitterIntegration.includeMatchWords;
      };

      globals = {
        matchup_surround_enabled = cfg.enableSurround;
        matchup_transmute_enabled = cfg.enableTransmute;

        matchup_delim_stopline = cfg.delimStopline;
        matchup_delim_noskips = cfg.delimNoSkips;

        matchup_matchparen_enabled = cfg.matchParen.enable;
        matchup_matchparen_fallback = cfg.matchParen.fallback;
        matchup_matchparen_offscreen = cfg.matchParen.offscreen;
        matchup_matchparen_stopline = cfg.matchParen.stopline;
        matchup_matchparen_timeout = cfg.matchParen.timeout;
        matchup_matchparen_insert_timeout = cfg.matchParen.insertTimeout;
        matchup_matchparen_deferred = cfg.matchParen.deferred.enable;
        matchup_matchparen_deferred_show_delay = cfg.matchParen.deferred.showDelay;
        matchup_matchparen_deferred_hide_delay = cfg.matchParen.deferred.hideDelay;
        matchup_matchparen_hi_surround_always = cfg.matchParen.hiSurroundAlways;

        matchup_motion_enabled = cfg.motion.enable;
        matchup_motion_override_Npercent = cfg.motion.overrideNPercent;
        matchup_motion_cursor_end = cfg.motion.cursorEnd;

        matchup_text_obj_enabled = cfg.textObj.enable;
        matchup_text_obj_linewise_operators = cfg.textObj.linewiseOperators;
      };
    };
}
