{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; {
  meta.maintainers = [maintainers.traxys];

  options.plugins.gitmessenger = {
    enable = mkEnableOption "gitmessenger";

    package = helpers.mkPackageOption "git-messenger" pkgs.vimPlugins.git-messenger-vim;

    closeOnCursorMoved = helpers.defaultNullOpts.mkBool true ''
      A popup window is no longer closed automatically when moving a cursor after the window is
      shown up.
    '';
    includeDiff = helpers.defaultNullOpts.mkEnumFirstDefault ["none" "current" "all"] ''
      When this value is not set to "none", a popup window includes diff hunks of the commit at
      showing up. "current" includes diff hunks of only current file in the commit. "all" includes
      all diff hunks in the commit.

      Please note that typing d/D or r/R in popup window toggle showing diff hunks even if this
      value is set to "none".
    '';
    gitCommand =
      helpers.defaultNullOpts.mkStr "git"
      "git command to retrieve commit messages.";
    noDefaultMappings =
      helpers.defaultNullOpts.mkBool false
      "When this value is set, it does not define any key mappings";
    intoPopupAfterShow = helpers.defaultNullOpts.mkBool true ''
      When this value is set to v:false, running :GitMessenger or <plug>(git-messenger) again after
      showing a popup does not move the cursor in the window.
    '';
    alwaysIntoPopup = helpers.defaultNullOpts.mkBool false ''
      When this value is set to v:true, the cursor goes into a popup window when running
      :GitMessenger or <Plug>(git-messenger).
    '';
    extraBlameArgs = helpers.defaultNullOpts.mkStr "" ''
      When this variable is set the contents will be appended to the git blame command. Use it to
      add options (like -w).
    '';
    previewMods = helpers.defaultNullOpts.mkStr "" ''
      This variable is effective only when opening preview window (on Neovim (0.3.0 or earlier)
      or Vim).

      Command modifiers for opening preview window. The value will be passed as prefix of :pedit
      command. For example, setting "botright" to the variable opens a preview window at bottom of
      the current window. Please see :help <mods> for more details.
    '';

    maxPopupHeight = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = ''
        Max lines of popup window in an integer value. Setting null means no limit.
      '';
    };

    maxPopupWidth = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = ''
        Max characters of popup window in an integer value. Setting null means no limit.
      '';
    };

    dateFormat = helpers.defaultNullOpts.mkStr "%c" ''
      String value to format dates in popup window. Please see :help strftime() to know the details
      of the format.
    '';

    concealWordDiffMarker = helpers.defaultNullOpts.mkBool true ''
      When this value is set to v:true, markers for word diffs like [-, -], {+, +} are concealed.
      Set false when you don't want to hide them.

      Note: Word diff is enabled by typing "r" in a popup window.
    '';

    floatingWinOps = helpers.defaultNullOpts.mkNullable (types.attrsOf types.anything) "{}" ''
      Options passed to nvim_open_win() on opening a popup window. This is useful when you want to
      override some window options.
    '';

    popupContentMargins = helpers.defaultNullOpts.mkBool true ''
      Setting true means adding margins in popup window. Blank lines at the top and bottom of popup
      content are inserted. And every line is indented with one whitespace character. Setting false
      to this variable removes all the margins.
    '';
  };

  config = let
    cfg = config.plugins.gitmessenger;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];
      globals = {
        git_messenger_close_on_cursor_moved = cfg.closeOnCursorMoved;
        git_messenger_include_diff = cfg.includeDiff;
        git_messenger_git_command = cfg.gitCommand;
        git_messenger_no_default_mappings = cfg.noDefaultMappings;
        git_messenger_into_popup_after_show = cfg.intoPopupAfterShow;
        git_messenger_always_into_popup = cfg.alwaysIntoPopup;
        git_messenger_extra_blame_args = cfg.extraBlameArgs;
        git_messenger_preview_mods = cfg.previewMods;
        git_messenger_max_popup_height = cfg.maxPopupHeight;
        git_messenger_max_popup_width = cfg.maxPopupWidth;
        git_messenger_date_format = cfg.dateFormat;
        git_messenger_conceal_word_diff_marker = cfg.concealWordDiffMarker;
        git_messenger_floating_win_opts = cfg.floatingWinOps;
        git_messenger_popup_content_margins = cfg.popupContentMargins;
      };
    };
}
