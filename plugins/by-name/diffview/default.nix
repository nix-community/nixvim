{
  lib,
  config,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "diffview";
  packPathName = "diffview.nvim";
  package = "diffview-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsOptions =
    let
      mkWinConfig =
        {
          type ? null,
          width ? null,
          height ? null,
          position ? null,
        }:
        {
          type =
            defaultNullOpts.mkEnum
              [
                "split"
                "float"
              ]
              type
              ''
                Determines whether the window should be a float or a normal
                split.
              '';

          width = defaultNullOpts.mkInt width ''
            The width of the window (in character cells). If `type` is
            `"split"` then this is only applicable when `position` is
            `"left"|"right"`.
          '';

          height = defaultNullOpts.mkInt height ''
            The height of the window (in character cells). If `type` is
            `"split"` then this is only applicable when `position` is
            `"top"|"bottom"`.
          '';

          position =
            defaultNullOpts.mkEnum
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
            defaultNullOpts.mkEnum
              [
                "editor"
                "win"
              ]
              "editor"
              ''
                Determines what the `position` is relative to (when
                `type="split"`).
              '';

          win = defaultNullOpts.mkInt 0 ''
            The window handle of the target relative window (when
            `type="split"`. Only when `relative="win"`). Use `0` for
            current window.
          '';

          win_opts = defaultNullOpts.mkAttributeSet { } ''
            Table of window local options (see |vim.opt_local|).
            These options are applied whenever the window is opened.
          '';
        };
    in
    {
      diff_binaries = defaultNullOpts.mkBool false ''
        Show diffs for binaries
      '';

      enhanced_diff_hl = defaultNullOpts.mkBool false ''
        See ':h diffview-config-enhanced_diff_hl'
      '';

      git_cmd = defaultNullOpts.mkListOf types.str [ "git" ] ''
        The git executable followed by default args.
      '';

      hg_cmd = defaultNullOpts.mkListOf types.str [ "hg" ] ''
        The hg executable followed by default args.
      '';

      use_icons = lib.lib.mkOption {
        type = types.bool;
        description = "Requires nvim-web-devicons";
        default = true;
      };

      show_help_hints = defaultNullOpts.mkBool true ''
        Show hints for how to open the help panel
      '';

      watch_index = defaultNullOpts.mkBool.true ''
        Update views and index buffers when the git index changes.
      '';

      icons = {
        folder_closed = defaultNullOpts.mkStr "" ''
          Only applies when use_icons is true.
        '';

        folder_open = defaultNullOpts.mkStr "" ''
          Only applies when use_icons is true.
        '';
      };

      signs = {
        fold_closed = defaultNullOpts.mkStr "" "";

        fold_open = defaultNullOpts.mkStr "" "";

        done = defaultNullOpts.mkStr "✓" "";
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
              defaultNullOpts.mkEnum
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

            winbarInfo = defaultNullOpts.mkBool.false ''
              See ':h diffview-config-view.x.winbar_info'
            '';
          };

          merge_tool = {
            layout =
              defaultNullOpts.mkEnum
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

            disable_diagnostics = defaultNullOpts.mkBool.true ''
              Temporarily disable diagnostics for conflict buffers while in the view.
            '';

            winbar_info = defaultNullOpts.mkBool.true ''
              See ':h diffview-config-view.x.winbar_info'
            '';
          };

          file_history = {
            layout =
              defaultNullOpts.mkEnum
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

            winbar_info = defaultNullOpts.mkBool.false ''
              See ':h diffview-config-view.x.winbar_info'
            '';
          };
        };

      file_panel = {
        listing_style =
          defaultNullOpts.mkEnum
            [
              "list"
              "tree"
            ]
            "tree"
            ''
              One of 'list' or 'tree'
            '';

        tree_options =
          let
            commonDesc = "Only applies when listing_style is 'tree'";
          in
          {
            flattenDirs = defaultNullOpts.mkBool.true ''
              Flatten dirs that only contain one single dir
              ${commonDesc}
            '';

            folderStatuses =
              defaultNullOpts.mkEnum
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
        win_config = mkWinConfig {
          type = "split";
          width = 35;
          position = "left";
        };
      };
      file_history_panel = {
        logOptions =
          let
            mkNullStr = lib.nixvim.mkNullOrOption types.str;
            mkNullBool = lib.nixvim.mkNullOrOption types.bool;
            logOptions = {
              base = mkNullStr ''
                Specify a base git rev from which the right side of the diff
                will be created. Use the special value `LOCAL` to use the
                local version of the file.
              '';

              rev_range = mkNullStr ''
                List only the commits in the specified revision range.
              '';

              path_args = defaultNullOpts.mkListOf.types.str [ ] ''
                Limit the target files to only the files matching the given
                path arguments (git pathspec is supported).
              '';

              follow = mkNullBool ''
                Follow renames (only for single file).
              '';

              first_parent = mkNullBool ''
                Follow only the first parent upon seeing a merge commit.
              '';

              show_pulls = mkNullBool ''
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

              no_merges = mkNullBool ''
                List no merge commits.
              '';

              reverse = mkNullBool ''
                List commits in reverse order.
              '';

              cherry_pick = mkNullBool ''
                Omit commits that introduce the same change as another commit
                on the "other side" when the set of commits are limited with
                symmetric difference.
              '';

              left_only = mkNullBool ''
                List only the commits on the left side of a symmetric
                difference.
              '';

              right_only = mkNullBool ''
                List only the commits on the right side of a symmetric
                difference.
              '';

              max_count = lib.nixvim.mkNullOrOption types.int ''
                Limit the number of commits.
              '';

              l = defaultNullOpts.mkListOf.types.str [ ] ''
                `{ ("<start>,<end>:<file>" | ":<funcname>:<file>")... }`

                Trace the evolution of the line range given by <start>,<end>,
                or by the function name regex <funcname>, within the <file>.
              '';

              diff_merges =
                lib.nixvim.mkNullOrOption
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
              single_file = logOptions;

              multi_file = logOptions;
            };
            hg = {
              single_file = logOptions;

              multi_file = logOptions;
            };
          };
        win_config = mkWinConfig {
          type = "split";
          height = 16;
          position = "bottom";
        };
      };

      commit_log_panel = {
        winConfig = mkWinConfig { type = "float"; };
      };

      default_args =
        let
          commonDesc = "Default args prepended to the arg-list for the listed commands";
        in
        {
          DiffviewOpen = defaultNullOpts.mkListOf.types.str [ ] commonDesc;

          DiffviewFileHistory = defaultNullOpts.mkListOf.types.str [ ] commonDesc;
        };

      hooks =
        let
          mkNullStr = lib.nixvim.mkNullOrOption types.str;
        in
        {
          view_opened = mkNullStr ''
            {view_opened} (`fun(view: View)`)

              Emitted after a new view has been opened. It's called after
              initializing the layout in the new tabpage (all windows are
              ready).

              Callback Parameters:
                  {view} (`View`)
                      The `View` instance that was opened.
          '';

          view_closed = mkNullStr ''
            {view_closed} (`fun(view: View)`)

                Emitted after closing a view.

                Callback Parameters:
                    {view} (`View`)
                        The `View` instance that was closed.
          '';

          view_enter = mkNullStr ''
            {view_enter} (`fun(view: View)`)

                Emitted just after entering the tabpage of a view.

                Callback Parameters:
                    {view} (`View`)
                        The `View` instance that was entered.
          '';

          view_leave = mkNullStr ''
            {view_leave} (`fun(view: View)`)

                Emitted just before leaving the tabpage of a view.

                Callback Parameters:
                    {view} (`View`)
                        The `View` instance that's about to be left.
          '';

          view_post_layout = mkNullStr ''
            {view_post_layout} (`fun(view: View)`)

                Emitted after the window layout in a view has been adjusted.

                Callback Parameters:
                    {view} (`View`)
                        The `View` whose layout was adjusted.
          '';

          diff_buf_read = mkNullStr ''
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

          diff_buf_win_enter = mkNullStr ''
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
            lib.mkOption {
              type = types.listOf (
                types.submodule {
                  options = {
                    mode = lib.mkOption {
                      type = types.str;
                      description = "mode to bind keybinding to";
                      example = "n";
                    };
                    key = lib.mkOption {
                      type = types.str;
                      description = "key to bind keybinding to";
                      example = "<tab>";
                    };
                    action = lib.mkOption {
                      type = types.str;
                      description = "action for keybinding";
                      example = "action.select_next_entry";
                    };
                    description = lib.mkOption {
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
          disable_defaults = defaultNullOpts.mkBool.false ''
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
          file_panel = keymapList ''
            Mappings in file panel.
          '';
          file_history_panel = keymapList ''
            Mappings in file history panel.
          '';
          option_panel = keymapList ''
            Mappings in options panel.
          '';
          help_panel = keymapList ''
            Mappings in help panel.
          '';
        };

      disable_default_keymaps = defaultNullOpts.mkBool.false ''
        Disable the default keymaps;
      '';
    };

  extraConfig =
    cfg:
    let
      setupOptions = with cfg; {
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
    {
    };

  inherit (import ./deprecations.nix { inherit lib; })
    imports
    optionsRenamedToSettings
    deprecateExtraOptions
    ;
}
