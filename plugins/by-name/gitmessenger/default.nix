{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
lib.nixvim.plugins.mkVimPlugin {
  name = "gitmessenger";
  packPathName = "git-messenger.vim";
  package = "git-messenger-vim";
  globalPrefix = "git_messenger_";

  maintainers = [ lib.maintainers.GaetanLepage ];

  extraOptions = {
    gitPackage = lib.mkPackageOption pkgs "git" {
      nullable = true;
    };
  };

  extraConfig = cfg: {
    extraPackages = [ cfg.gitPackage ];
  };

  # TODO: Added 2024-12-16; remove after 25.05
  optionsRenamedToSettings = [
    "closeOnCursorMoved"
    "includeDiff"
    "gitCommand"
    "noDefaultMappings"
    "intoPopupAfterShow"
    "alwaysIntoPopup"
    "extraBlameArgs"
    "previewMods"
    "maxPopupHeight"
    "maxPopupWidth"
    "dateFormat"
    "concealWordDiffMarker"
    "floatingWinOps"
    "popupContentMargins"
  ];

  settingsOptions = {
    close_on_cursor_moved = defaultNullOpts.mkBool true ''
      A popup window is no longer closed automatically when moving a cursor after the window is
      shown up.
    '';

    include_diff =
      defaultNullOpts.mkEnumFirstDefault
        [
          "none"
          "current"
          "all"
        ]
        ''
          When this value is not set to `"none"`, a popup window includes diff hunks of the commit
          at showing up.
          `"current"` includes diff hunks of only current file in the commit.
          `"all"` includes all diff hunks in the commit.

          Please note that typing `d`/`D` or `r`/`R` in popup window toggle showing diff hunks even
          if this value is set to `"none"`.
        '';

    git_command = defaultNullOpts.mkStr "git" ''
      `git` command to retrieve commit messages.

      If your `git` executable is not in `$PATH` directories, please specify the path to the
      executable.
    '';

    no_default_mappings = defaultNullOpts.mkBool false ''
      When this value is set, it does not define any key mappings.
    '';

    into_popup_after_show = defaultNullOpts.mkBool true ''
      When this value is set to `false`, running `:GitMessenger` or `<plug>(git-messenger)` again
      after showing a popup does not move the cursor in the window.
    '';

    always_into_popup = defaultNullOpts.mkBool false ''
      When this value is set to `true`, the cursor goes into a popup window when running
      `:GitMessenger` or `<Plug>(git-messenger)`.
    '';

    extra_blame_args = defaultNullOpts.mkStr "" ''
      When this variable is set the contents will be appended to the git blame command. Use it to
      add options (like -w).
    '';

    preview_mods = defaultNullOpts.mkStr "" ''
      This variable is effective only when opening preview window (on Neovim (0.3.0 or earlier)
      or Vim).

      Command modifiers for opening preview window.
      The value will be passed as prefix of `:pedit` command.

      For example, setting `"botright"` to the variable opens a preview window at bottom of the
      current window.
      Please see `:help <mods>` for more details.
    '';

    max_popup_height = defaultNullOpts.mkUnsignedInt null ''
      Max lines of popup window in an integer value.
      Setting `null` means no limit.
    '';

    max_popup_width = defaultNullOpts.mkUnsignedInt null ''
      Max characters of popup window in an integer value.
      Setting `null` means no limit.
    '';

    date_format = defaultNullOpts.mkStr "%c" ''
      String value to format dates in popup window.

      Please see `:help strftime()` to know the details of the format.
    '';

    conceal_word_diff_marker = defaultNullOpts.mkBool true ''
      When this value is set to `true`, markers for word diffs like `[-, -]`, `{+, +}` are
      concealed.
      Set `false` when you don't want to hide them.

      Note: Word diff is enabled by typing `r` in a popup window.
    '';

    floating_win_opts = defaultNullOpts.mkAttrsOf' {
      type = types.anything;
      pluginDefault = { };
      example = {
        border = "single";
      };
      description = ''
        Options passed to `nvim_open_win()` on opening a popup window.

        This is useful when you want to override some window options.
      '';
    };

    popup_content_margins = defaultNullOpts.mkBool true ''
      Setting `true` means adding margins in popup window.
      Blank lines at the top and bottom of popup content are inserted.
      And every line is indented with one whitespace character.

      Setting `false` to this variable removes all the margins.
    '';
  };

  settingsExample = {
    extra_blame_args = "-w";
    include_diff = "current";
    floating_win_opts.border = "single";
  };
}
