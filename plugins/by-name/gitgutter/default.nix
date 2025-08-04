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
  name = "gitgutter";
  packPathName = "vim-gitgutter";
  package = "vim-gitgutter";
  globalPrefix = "gitgutter_";
  description = "A Vim plugin which shows a git diff in the sign column.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  # TODO introduced 2024-12-16: remove after 25.05
  optionsRenamedToSettings = import ./renamed-options.nix lib;
  imports =
    let
      basePluginPath = [
        "plugins"
        "gitgutter"
      ];
    in
    [
      (lib.mkRemovedOptionModule (
        basePluginPath ++ [ "grep" ]
      ) "Please, use `plugins.gitgutter.grepPackage` and/or `plugins.gitgutter.settings.grep`.")
      (lib.mkRemovedOptionModule (
        basePluginPath
        ++ [
          "signs"
          "modifiedAbove"
        ]
      ) "This option has been removed from upstream")

      # TODO: added 2025-04-06, remove after 25.05
      (lib.nixvim.mkRemovedPackageOptionModule {
        plugin = "gitgutter";
        packageName = "git";
      })
    ];

  dependencies = [ "git" ];

  extraOptions = {
    recommendedSettings = lib.mkOption {
      type = types.bool;
      default = true;
      description = ''
        Set recommended neovim option.
      '';
    };

    grepPackage = lib.mkPackageOption pkgs "gnugrep" {
      nullable = true;
    };
  };

  extraConfig = cfg: {
    opts = lib.optionalAttrs cfg.recommendedSettings {
      updatetime = 100;
      foldtext = "gitgutter#fold#foldtext";
    };

    extraPackages = [
      cfg.grepPackage
    ];
  };

  settingsOptions = {
    preview_win_location = defaultNullOpts.mkEnumFirstDefault [ "bo" "to" "bel" "abo" ] ''
      This option determines where the preview window pops up as a result of the
      `:GitGutterPreviewHunk` command.

      See the end of the `|opening-window|` docs.
    '';

    git_executable = defaultNullOpts.mkStr' {
      pluginDefault = "git";
      example = lib.literalExpression "lib.getExe pkgs.git";
      description = ''
        This option determines what `git` binary to use.
        Set this if git is not on your path.
      '';
    };

    git_args = defaultNullOpts.mkStr' {
      pluginDefault = "";
      example = ''--gitdir=""'';
      description = ''
        Use this option to pass any extra arguments to `git` when running `git-diff`.
      '';
    };

    diff_args = defaultNullOpts.mkStr' {
      pluginDefault = "";
      example = "-w";
      description = ''
        Use this option to pass any extra arguments to `git-diff`.
      '';
    };

    diff_relative_to = defaultNullOpts.mkStr' {
      pluginDefault = "index";
      example = "working_tree";
      description = ''
        By default buffers are diffed against the index.
        Use this option to diff against the working tree.
      '';
    };

    diff_base = defaultNullOpts.mkStr' {
      pluginDefault = "";
      example = "";
      description = ''
        By default buffers are diffed against the index.
        Use this option to diff against a revision instead.

        If you are looking at a previous version of a file with _Fugitive_ (e.g. via `:0Gclog`),
        gitgutter sets the diff base to the parent of the current revision.

        This setting is ignore when the diff is relative to the working tree (`diff_relative_to`).
      '';
    };

    grep = defaultNullOpts.mkStr' {
      pluginDefault = "grep";
      example = "grep --color=never";
      description = ''
        The plugin pipes the output of `git-diff` into `grep` to minimise the amount of data vim has
        to process.
        Set this option if `grep` is not on your path.

        `grep` must produce plain-text output without any ANSI escape codes or colours.
        Use this option to turn off colours if necessary (`grep --color=never` for example).

        If you do not want to use `grep` at all (perhaps to debug why signs are not showing), set
        this option to an empty string.
      '';
    };

    signs = defaultNullOpts.mkBool true ''
      Determines whether or not to show signs.
    '';

    highlight_lines = defaultNullOpts.mkBool false ''
      Determines whether or not to show line highlights.
    '';

    highlight_linenrs = defaultNullOpts.mkBool false ''
      Determines whether or not to show line number highlights.
    '';

    max_signs = defaultNullOpts.mkInt (-1) ''
      Sets the maximum number of signs to show in a buffer.

      To avoid slowing down the GUI the number of signs can be capped.
      When the number of changed lines exceeds this value, the plugin removes all signs and displays
      a warning message.

      When set to `-1` the limit is not applied.
    '';

    sign_priority = defaultNullOpts.mkUnsignedInt 10 ''
      Sets the `|sign-priority|` gitgutter assigns to its signs.
    '';

    sign_allow_clobber = defaultNullOpts.mkBool true ''
      Determines whether gitgutter preserves non-gitgutter signs.
      When `true`, gitgutter will not preserve non-gitgutter signs.
    '';
  }
  // (lib.mapAttrs'
    (n: default: {
      name = "sign_${n}";
      value = defaultNullOpts.mkStr default ''
        Icon for the _${n}_ sign.

        You can use unicode characters but not images.
        Signs must not take up more than 2 columns.
      '';
    })
    {
      added = "+";
      modified = "~";
      removed = "_";
      removed_first_line = "‾";
      removed_above_and_below = "_¯";
      modified_removed = "~_";
    }
  )
  // {
    set_sign_backgrounds = defaultNullOpts.mkBool false ''
      Only applies to existing `GitGutter*` highlight groups.
      See `|gitgutter-highlights|`.

      Controls whether to override the signs' background colours to match the `|hl-SignColumn|`.
    '';

    preview_win_floating = defaultNullOpts.mkBool true ''
      Whether to use floating/popup windows for hunk previews.

      Note that if you use popup windows on Vim you will not be able to stage partial hunks via
      the preview window.
    '';

    floating_window_options =
      defaultNullOpts.mkAttrsOf types.anything
        {
          relative = "cursor";
          row = 1;
          col = 0;
          width = 42;
          height = "&previewheight";
          style = "minimal";
        }
        ''
          This dictionary is passed directly to `|nvim_open_win()|`.
        '';

    close_preview_on_escape = defaultNullOpts.mkBool false ''
      Whether pressing <Esc> in a preview window closes it.
    '';

    terminal_reports_focus = defaultNullOpts.mkBool true ''
      Normally the plugin uses `|FocusGained|` to force-update all buffers when Vim receives
      focus.
      However some terminals do not report focus events and so the `|FocusGained|` autocommand
      never fires.

      If this applies to you, either install something like
      [Terminus](https://github.com/wincent/terminus) to make `|FocusGained|` work or set this
      option to `false`.

      If you use `tmux`, try this in your tmux.conf:
      ```
      set -g focus-events on
      ```

      When this option is `false`, the plugin force-updates the buffer on `|BufEnter|` (instead of
      only updating if the buffer's contents has changed since the last update).

    '';

    enabled = defaultNullOpts.mkBool true ''
      Controls whether or not the plugin is on at startup.
    '';

    map_keys = defaultNullOpts.mkBool true ''
      Controls whether or not the plugin provides mappings.
      See `|gitgutter-mappings|`.
    '';

    async = defaultNullOpts.mkBool true ''
      Controls whether or not diffs are run in the background.
    '';

    log = defaultNullOpts.mkBool false ''
      When switched on, the plugin logs to `gitgutter.log` in the directory where it is installed.
      Additionally it logs channel activity to `channel.log`.
    '';

    use_location_list = defaultNullOpts.mkBool false ''
      When switched on, the `:GitGutterQuickFix` command populates the location list of the
      current window instead of the global quickfix list.
    '';

    show_msg_on_hunk_jumping = defaultNullOpts.mkBool true ''
      When switched on, a message like "Hunk 4 of 11" is shown on hunk jumping.
    '';
  };

  settingsExample = {
    set_sign_backgrounds = true;
    sign_modified_removed = "*";
    sign_priority = 20;
    preview_win_floating = true;
  };
}
