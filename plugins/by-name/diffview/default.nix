{
  lib,
  helpers,
  config,
  pkgs,
  options,
  ...
}:
with lib;
let
  cfg = config.plugins.diffview;
  mkWinConfig =
    {
      type ? null,
      width ? null,
      height ? null,
      position ? null,
    }:
    with helpers.defaultNullOpts;
    {
      type =
        mkEnum
          [
            "split"
            "float"
          ]
          type
          ''
            Determines whether the window should be a float or a normal
            split.
          '';

      width = mkInt width ''
        The width of the window (in character cells). If `type` is
        `"split"` then this is only applicable when `position` is
        `"left"|"right"`.
      '';

      height = mkInt height ''
        The height of the window (in character cells). If `type` is
        `"split"` then this is only applicable when `position` is
        `"top"|"bottom"`.
      '';

      position =
        mkEnum
          [
            "left"
            "top"
            "right"
            "bottom"
          ]
          position
          ''
            Determines where the panel is positioned (only when
            `type="split"`).
          '';

      relative =
        mkEnum
          [
            "editor"
            "win"
          ]
          "editor"
          ''
            Determines what the `position` is relative to (when
            `type="split"`).
          '';

      win = mkInt 0 ''
        The window handle of the target relative window (when
        `type="split"`. Only when `relative="win"`). Use `0` for
        current window.
      '';

      winOpts = mkAttributeSet { } ''
        Table of window local options (see |vim.opt_local|).
        These options are applied whenever the window is opened.
      '';
    };
in
{
  options.plugins.diffview =
    with helpers.defaultNullOpts;
    helpers.neovim-plugin.extraOptionsOptions
    // {
      enable = mkEnableOption "diffview";

      package = lib.mkPackageOption pkgs "diffview" {
        default = [
          "vimPlugins"
          "diffview-nvim"
        ];
      };

      diffBinaries = mkBool false ''
        Show diffs for binaries
      '';

      enhancedDiffHl = mkBool false ''
        See ':h diffview-config-enhanced_diff_hl'
      '';

      gitCmd = mkListOf types.str [ "git" ] ''
        The git executable followed by default args.
      '';

      hgCmd = mkListOf types.str [ "hg" ] ''
        The hg executable followed by default args.
      '';

      useIcons = mkOption {
        type = types.bool;
        description = "Requires nvim-web-devicons";
        default = true;
      };

      showHelpHints = mkBool true ''
        Show hints for how to open the help panel
      '';

      watchIndex = mkBool true ''
        Update views and index buffers when the git index changes.
      '';

      icons = {
        folderClosed = mkStr "" ''
          Only applies when use_icons is true.
        '';

        folderOpen = mkStr "" ''
          Only applies when use_icons is true.
        '';
      };

      signs = {
        foldClosed = mkStr "" "";

        foldOpen = mkStr "" "";

        done = mkStr "✓" "";
      };

      view =
        let
          layoutsDescription = ''
            Configure the layout and behavior of different types of views.
            For more info, see ':h diffview-config-view.x.layout'.
          '';
          diff2HorizontalDescription = ''
            diff2_horizontal:

            | A | B |
          '';
          diff2VerticalDescription = ''
            diff2_vertical:


            A

            ─

            B
          '';
        in
        {
          default = {
            layout =
              mkEnum
                [
                  "diff2_horizontal"
                  "diff2_vertical"
                ]
                "diff2_horizontal"
                ''
                  Config for changed files, and staged files in diff views.
                  ${layoutsDescription}
                  - A: Old state
                  - B: New state

                  ${diff2HorizontalDescription}

                  ${diff2VerticalDescription}
                '';

            winbarInfo = mkBool false ''
              See ':h diffview-config-view.x.winbar_info'
            '';
          };

          mergeTool = {
            layout =
              mkEnum
                [
                  "diff1_plain"
                  "diff3_horizontal"
                  "diff3_vertical"
                  "diff3_mixed"
                  "diff4_mixed"
                ]
                "diff3_horizontal"
                ''
                  Config for conflicted files in diff views during a merge or rebase.
                  ${layoutsDescription}
                  - A: OURS (current branch)
                  - B: LOCAL (the file as it currently exists on disk)
                  - C: THEIRS (incoming branch)
                  - D: BASE (common ancestor)

                  diff1_plain:

                  B

                  diff3_horizontal:

                  A | B | C

                  diff3_vertical:

                  A

                  B

                  C

                  diff3_mixed:

                  A | C

                  B

                  diff4_mixed:

                  A | D | C

                  B

                '';

            disableDiagnostics = mkBool true ''
              Temporarily disable diagnostics for conflict buffers while in the view.
            '';

            winbarInfo = mkBool true ''
              See ':h diffview-config-view.x.winbar_info'
            '';
          };

          fileHistory = {
            layout =
              mkEnum
                [
                  "diff2_horizontal"
                  "diff2_vertical"
                ]
                "diff2_horizontal"
                ''
                  Config for changed files in file history views.
                  ${layoutsDescription}
                  - A: Old state
                  - B: New state

                  ${diff2HorizontalDescription}

                  ${diff2VerticalDescription}
                '';

            winbarInfo = mkBool false ''
              See ':h diffview-config-view.x.winbar_info'
            '';
          };
        };

      filePanel = {
        listingStyle =
          mkEnum
            [
              "list"
              "tree"
            ]
            "tree"
            ''
              One of 'list' or 'tree'
            '';

        treeOptions =
          let
            commonDesc = "Only applies when listing_style is 'tree'";
          in
          {
            flattenDirs = mkBool true ''
              Flatten dirs that only contain one single dir
              ${commonDesc}
            '';

            folderStatuses =
              mkEnum
                [
                  "never"
                  "only_folded"
                  "always"
                ]
                "only_folded"
                ''
                  One of 'never', 'only_folded' or 'always'.
                  ${commonDesc}
                '';
          };
        winConfig = mkWinConfig {
          type = "split";
          width = 35;
          position = "left";
        };
      };
      fileHistoryPanel = {
        logOptions =
          let
            mkNullStr = helpers.mkNullOrOption types.str;
            mkNullBool = helpers.mkNullOrOption types.bool;
            logOptions = {
              base = mkNullStr ''
                Specify a base git rev from which the right side of the diff
                will be created. Use the special value `LOCAL` to use the
                local version of the file.
              '';

              revRange = mkNullStr ''
                List only the commits in the specified revision range.
              '';

              pathArgs = mkListOf types.str [ ] ''
                Limit the target files to only the files matching the given
                path arguments (git pathspec is supported).
              '';

              follow = mkNullBool ''
                Follow renames (only for single file).
              '';

              firstParent = mkNullBool ''
                Follow only the first parent upon seeing a merge commit.
              '';

              showPulls = mkNullBool ''
                Show merge commits that are not TREESAME to its first parent,
                but are to a later parent.
              '';

              reflog = mkNullBool ''
                Include all reachable objects mentioned by reflogs.
              '';

              all = mkNullBool ''
                Include all refs.
              '';

              merges = mkNullBool ''
                List only merge commits.
              '';

              noMerges = mkNullBool ''
                List no merge commits.
              '';

              reverse = mkNullBool ''
                List commits in reverse order.
              '';

              cherryPick = mkNullBool ''
                Omit commits that introduce the same change as another commit
                on the "other side" when the set of commits are limited with
                symmetric difference.
              '';

              leftOnly = mkNullBool ''
                List only the commits on the left side of a symmetric
                difference.
              '';

              rightOnly = mkNullBool ''
                List only the commits on the right side of a symmetric
                difference.
              '';

              maxCount = helpers.mkNullOrOption types.int ''
                Limit the number of commits.
              '';

              l = mkListOf types.str [ ] ''
                `{ ("<start>,<end>:<file>" | ":<funcname>:<file>")... }`

                Trace the evolution of the line range given by <start>,<end>,
                or by the function name regex <funcname>, within the <file>.
              '';

              diffMerges =
                helpers.mkNullOrOption
                  (types.enum [
                    "off"
                    "on"
                    "first-parent"
                    "separate"
                    "combined"
                    "dense-combined"
                    "remerge"
                  ])
                  ''
                    Determines how merge commits are treated.
                  '';

              author = mkNullStr ''
                Limit the commits output to ones with author/committer header
                lines that match the specified pattern (regular expression).
              '';

              grep = mkNullStr ''
                Limit the commits output to ones with log message that matches
                the specified pattern (regular expression).
              '';

              g = mkNullStr ''
                Look for differences whose patch text contains added/removed
                lines that match the specified pattern (extended regular
                expression).
              '';

              s = mkNullStr ''
                Look for differences that change the number of occurrences of
                the specified pattern (extended regular expression) in a
                file.
              '';
            };
          in
          {
            git = {
              singleFile = logOptions;

              multiFile = logOptions;
            };
            hg = {
              singleFile = logOptions;

              multiFile = logOptions;
            };
          };
        winConfig = mkWinConfig {
          type = "split";
          height = 16;
          position = "bottom";
        };
      };

      commitLogPanel = {
        winConfig = mkWinConfig { type = "float"; };
      };

      defaultArgs =
        let
          commonDesc = "Default args prepended to the arg-list for the listed commands";
        in
        {
          diffviewOpen = mkListOf types.str [ ] commonDesc;

          diffviewFileHistory = mkListOf types.str [ ] commonDesc;
        };

      hooks =
        let
          mkNullStr = helpers.mkNullOrOption types.str;
        in
        {
          viewOpened = mkNullStr ''
            {view_opened} (`fun(view: View)`)

              Emitted after a new view has been opened. It's called after
              initializing the layout in the new tabpage (all windows are
              ready).

              Callback Parameters:
                  {view} (`View`)
                      The `View` instance that was opened.
          '';

          viewClosed = mkNullStr ''
            {view_closed} (`fun(view: View)`)

                Emitted after closing a view.

                Callback Parameters:
                    {view} (`View`)
                        The `View` instance that was closed.
          '';

          viewEnter = mkNullStr ''
            {view_enter} (`fun(view: View)`)

                Emitted just after entering the tabpage of a view.

                Callback Parameters:
                    {view} (`View`)
                        The `View` instance that was entered.
          '';

          viewLeave = mkNullStr ''
            {view_leave} (`fun(view: View)`)

                Emitted just before leaving the tabpage of a view.

                Callback Parameters:
                    {view} (`View`)
                        The `View` instance that's about to be left.
          '';

          viewPostLayout = mkNullStr ''
            {view_post_layout} (`fun(view: View)`)

                Emitted after the window layout in a view has been adjusted.

                Callback Parameters:
                    {view} (`View`)
                        The `View` whose layout was adjusted.
          '';

          diffBufRead = mkNullStr ''
            {diff_buf_read} (`fun(bufnr: integer, ctx: table)`)

                Emitted after a new diff buffer is ready (the first time it's
                created and loaded into a window). Diff buffers are all
                buffers with |diff-mode| enabled. That includes buffers of
                local files (not created from git).

                This is always called with the new buffer as the current
                buffer and the correct diff window as the current window such
                that |:setlocal| will apply settings to the relevant buffer /
                window.

                Callback Parameters:
                    {bufnr} (`integer`)
                        The buffer number of the new buffer.
                    {ctx} (`table`)
                        • {symbol} (string)
                          A symbol that identifies the window's position in
                          the layout. These symbols correspond with the
                          figures under |diffview-config-view.x.layout|.
                        • {layout_name} (string)
                          The name of the current layout.
          '';

          diffBufWinEnter = mkNullStr ''
            {diff_buf_win_enter} (`fun(bufnr: integer, winid: integer, ctx: table)`)

                Emitted after a diff buffer is displayed in a window.

                This is always called with the new buffer as the current
                buffer and the correct diff window as the current window such
                that |:setlocal| will apply settings to the relevant buffer /
                window.

                Callback Parameters:
                    {bufnr} (`integer`)
                        The buffer number of the new buffer.
                    {winid} (`integer`)
                        The window id of window inside which the buffer was
                        displayed.
                    {ctx} (`table`)
                        • {symbol} (string)
                          A symbol that identifies the window's position in
                          the layout. These symbols correspond with the
                          figures under |diffview-config-view.x.layout|.
                        • {layout_name} (string)
                          The name of the current layout.
          '';
        };

      keymaps =
        let
          keymapList =
            desc:
            mkOption {
              type = types.listOf (
                types.submodule {
                  options = {
                    mode = mkOption {
                      type = types.str;
                      description = "mode to bind keybinding to";
                      example = "n";
                    };
                    key = mkOption {
                      type = types.str;
                      description = "key to bind keybinding to";
                      example = "<tab>";
                    };
                    action = mkOption {
                      type = types.str;
                      description = "action for keybinding";
                      example = "action.select_next_entry";
                    };
                    description = mkOption {
                      type = types.nullOr types.str;
                      description = "description for keybinding";
                      default = null;
                    };
                  };
                }
              );
              description = ''
                List of keybindings.
                ${desc}
              '';
              default = [ ];
              example = [
                {
                  mode = "n";
                  key = "<tab>";
                  action = "actions.select_next_entry";
                  description = "Open the diff for the next file";
                }
              ];
            };
        in
        {
          disableDefaults = mkBool false ''
            Disable the default keymaps.
          '';

          view = keymapList ''
            The `view` bindings are active in the diff buffers, only when the current
            tabpage is a Diffview.
          '';

          diff1 = keymapList ''
            Mappings in single window diff layouts
          '';

          diff2 = keymapList ''
            Mappings in 2-way diff layouts
          '';
          diff3 = keymapList ''
            Mappings in 3-way diff layouts
          '';
          diff4 = keymapList ''
            Mappings in 4-way diff layouts
          '';
          filePanel = keymapList ''
            Mappings in file panel.
          '';
          fileHistoryPanel = keymapList ''
            Mappings in file history panel.
          '';
          optionPanel = keymapList ''
            Mappings in options panel.
          '';
          helpPanel = keymapList ''
            Mappings in help panel.
          '';
        };

      disableDefaultKeymaps = mkBool false ''
        Disable the default keymaps;
      '';
    };

  config =
    let
      setupOptions = with cfg; {
        diff_binaries = diffBinaries;
        enhanced_diff_hl = enhancedDiffHl;
        git_cmd = gitCmd;
        hg_cmd = hgCmd;
        use_icons = useIcons;
        show_help_hints = showHelpHints;
        watch_index = watchIndex;

        icons = {
          folder_closed = icons.folderClosed;
          folder_open = icons.folderOpen;
        };

        signs = with signs; {
          fold_closed = foldClosed;
          fold_open = foldOpen;
          inherit done;
        };

        view = with view; {
          default = with default; {
            inherit layout;
            winbar_info = winbarInfo;
          };

          merge_tool = with mergeTool; {
            inherit layout;
            disable_diagnostics = disableDiagnostics;
            winbar_info = winbarInfo;
          };

          file_history = with fileHistory; {
            inherit layout;
            winbar_info = winbarInfo;
          };
        };

        file_panel = with filePanel; {
          listing_style = listingStyle;

          tree_options = with treeOptions; {
            flatten_dirs = flattenDirs;
            folder_statuses = folderStatuses;
          };

          win_config = with winConfig; {
            inherit type;
            inherit width;
            inherit height;
            inherit position;
            inherit relative;
            inherit win;
            win_opts = winOpts;
          };
        };

        file_history_panel = with fileHistoryPanel; {
          log_options =
            with logOptions;
            let
              setupLogOptions =
                opts: with opts; {
                  inherit base;
                  rev_range = revRange;
                  path_args = pathArgs;
                  inherit follow;
                  first_parent = firstParent;
                  show_pulls = showPulls;
                  inherit reflog;
                  inherit all;
                  inherit merges;
                  no_merges = noMerges;
                  inherit reverse;
                  cherry_pick = cherryPick;
                  left_only = leftOnly;
                  right_only = rightOnly;
                  max_count = maxCount;
                  L = l;
                  diff_merges = diffMerges;
                  inherit author;
                  inherit grep;
                  G = g;
                  S = s;
                };
            in
            {
              git = with git; {
                single_file = setupLogOptions singleFile;
                multi_file = setupLogOptions multiFile;
              };

              hg = with hg; {
                single_file = setupLogOptions singleFile;
                multi_file = setupLogOptions multiFile;
              };
            };

          win_config = with winConfig; {
            inherit type;
            inherit width;
            inherit height;
            inherit position;
            inherit relative;
            inherit win;
            win_opts = winOpts;
          };
        };

        commit_log_panel = with commitLogPanel; {
          win_config = with winConfig; {
            inherit type;
            inherit width;
            inherit height;
            inherit position;
            inherit relative;
            inherit win;
            win_opts = winOpts;
          };
        };

        default_args = with defaultArgs; {
          DiffviewOpen = diffviewOpen;
          DiffviewFileHistory = diffviewFileHistory;
        };

        hooks = with hooks; {
          view_opened = viewOpened;
          view_closed = viewClosed;
          view_enter = viewEnter;
          view_leave = viewLeave;
          view_post_layout = viewPostLayout;
          diff_buf_read = diffBufRead;
          diff_buf_win_enter = diffBufWinEnter;
        };

        keymaps =
          with keymaps;
          let
            convertToKeybinding = attr: [
              attr.mode
              attr.key
              attr.action
              { "desc" = attr.description; }
            ];
          in
          {
            view = map convertToKeybinding view;
            diff1 = map convertToKeybinding diff1;
            diff2 = map convertToKeybinding diff2;
            diff3 = map convertToKeybinding diff3;
            diff4 = map convertToKeybinding diff4;
            file_panel = map convertToKeybinding filePanel;
            file_history_panel = map convertToKeybinding fileHistoryPanel;
            option_panel = map convertToKeybinding optionPanel;
            help_panel = map convertToKeybinding helpPanel;
          };
      };
    in
    mkIf cfg.enable {
      # TODO: added 2024-09-20 remove after 24.11
      plugins.web-devicons = mkIf (
        !(
          config.plugins.mini.enable
          && config.plugins.mini.modules ? icons
          && config.plugins.mini.mockDevIcons
        )
      ) { enable = mkOverride 1490 true; };

      extraPlugins = [ cfg.package ];

      extraConfigLua = ''
        require("diffview").setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
