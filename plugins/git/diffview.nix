{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.diffview;
  helpers = import ../helpers.nix {inherit lib;};
in {
  options.plugins.diffview = with helpers.defaultNullOpts;
    helpers.extraOptionsOptions
    // {
      enable = mkEnableOption "diffview";

      package = helpers.mkPackageOption "diffview" pkgs.vimPlugins.diffview-nvim;

      diffBinaries = mkBool false ''
        Show diffs for binaries
      '';

      enhancedDiffHl = mkBool false ''
        See ':h diffview-config-enhanced_diff_hl'
      '';

      gitCmd = mkNullable (types.listOf types.str) ''[ "git" ]'' ''
        The git executable followed by default args.
      '';

      hgCmd = mkNullable (types.listOf types.str) ''[ "hg" ]'' ''
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

      view = let
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
      in {
        default = {
          layout = mkEnum ["diff2_horizontal" "diff2_vertical"] "diff2_horizontal" ''
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
          layout = mkEnum ["diff1_plain" "diff3_horizontal" "diff3_vertical" "diff3_mixed" "diff4_mixed"] "diff3_horizontal" ''
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
          layout = mkEnum ["diff2_horizontal" "diff2_vertical"] "diff2_horizontal" ''
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
        listingStyle = mkEnum ["list" "tree"] "tree" ''
          One of 'list' or 'tree'
        '';

        treeOptions = let
          commonDesc = "Only applies when listing_style is 'tree'";
        in {
          flattenDirs = mkBool true ''
            Flatten dirs that only contain one single dir
            ${commonDesc}
          '';

          folderStatuses = mkEnum ["never" "only_folded" "always"] "only_folded" ''
            One of 'never', 'only_folded' or 'always'.
            ${commonDesc}
          '';
        };
        winConfig = let
          commonDesc = "See ':h diffview-config-win_config'";
        in {
          position = mkStr "left" commonDesc;

          width = mkInt 35 commonDesc;

          winOpts = mkAttributeSet "{ a = 1;}" commonDesc;
        };
      };
      fileHistoryPanel = {
        logOptions = let
          commonDesc = "See ':h diffview-config-log_options'";
        in {
          git = {
            singleFile = {
              diffMerges = mkStr "combined" commonDesc;
            };

            multiFile = {
              diffMerges = mkStr "first-parent" commonDesc;
            };
          };
          hg = {
            singleFile = mkAttributeSet "{}" commonDesc;

            multiFile = mkAttributeSet "{}" commonDesc;
          };
        };
        winConfig = let
          commonDesc = "See ':h diffview-config-win_config'";
        in {
          position = mkStr "bottom" commonDesc;

          height = mkInt 16 commonDesc;

          winOpts = mkAttributeSet "{}" commonDesc;
        };
      };

      commitLogPanel = {
        winConfig = {
          winOpts = mkAttributeSet "{}" ''
            See ':h diffview-config-win_config'
          '';
        };
      };

      defaultArgs = let
        commonDesc = "Default args prepended to the arg-list for the listed commands";
      in {
        diffviewOpen = mkNullable (types.listOf types.str) "[ ]" commonDesc;

        diffviewFileHistory = mkNullable (types.listOf types.str) "[ ]" commonDesc;
      };

      hooks = let
        mkNullStr = helpers.mkNullOrOption types.str;
      in {
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

      keymaps = let
        keymapList = desc:
          mkOption {
            type = types.listOf (types.submodule {
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
            });
            description = ''
              List of keybindings.
              ${desc}
            '';
            default = [];
            example = [
              {
                mode = "n";
                key = "<tab>";
                action = "actions.select_next_entry";
                description = "Open the diff for the next file";
              }
            ];
          };
      in {
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

  config = let
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
          inherit position;
          inherit width;
          win_opts = winOpts;
        };
      };

      file_history_panel = with fileHistoryPanel; {
        log_options = with logOptions; {
          git = with git; {
            single_file = {
              diff_merges = singleFile.diffMerges;
            };

            multi_file = {
              diff_merges = multiFile.diffMerges;
            };
          };

          hg = with hg; {
            single_file = singleFile;
            multi_file = multiFile;
          };
        };

        win_config = with winConfig; {
          inherit position;
          inherit height;
          win_opts = winOpts;
        };
      };

      commit_log_panel = {
        win_config = {
          win_opts = commitLogPanel.winConfig.winOpts;
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

      keymaps = with keymaps; let
        convertToKeybinding = attr: [attr.mode attr.key attr.action {"desc" = attr.description;}];
      in {
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
    mkIf
    cfg.enable
    {
      extraPlugins =
        [cfg.package]
        ++ (optional cfg.useIcons pkgs.vimPlugins.nvim-web-devicons);
      extraConfigLua = ''
        require("diffview").setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
