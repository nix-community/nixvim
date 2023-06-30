{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.diffview;
  helpers = import ../helpers.nix {inherit lib;};
  mkAttributeSet = helpers.defaultNullOpts.mkNullable types.attrs "{}";

  layoutsDescription = ''
    Configure the layout and behavior of different types of views.
    Available layouts:
     'diff1_plain'
       |'diff2_horizontal'
       |'diff2_vertical'
       |'diff3_horizontal'
       |'diff3_vertical'
       |'diff3_mixed'
       |'diff4_mixed'
    For more info, see ':h diffview-config-view.x.layout'.
  '';
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

      gitCmd = mkNullable (types.listOf types.str) "[ \"git\" ]" ''
        The git executable followed by default args.
      '';

      hgCmd = mkNullable (types.listOf types.str) "[ \"hg\" ]" ''
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

      view = {
        default = {
          layout = mkStr "diff2_horizontal" ''
            Config for changed files, and staged files in diff views.
            ${layoutsDescription}
          '';

          winbarInfo = mkBool false ''
            See ':h diffview-config-view.x.winbar_info'
          '';
        };

        mergeTool = {
          layout = mkStr "diff3_horizontal" ''
            Config for conflicted files in diff views during a merge or rebase.
            ${layoutsDescription}
          '';

          disableDiagnostics = mkBool true ''
            Temporarily disable diagnostics for conflict buffers while in the view.
          '';

          winbarInfo = mkBool true ''
            See ':h diffview-config-view.x.winbar_info'
          '';
        };

        fileHistory = {
          layout = mkStr "diff2_horizontal" ''
            Config for changed files in file history views.
            ${layoutsDescription}
          '';

          winbarInfo = mkBool false ''
            See ':h diffview-config-view.x.winbar_info'
          '';
        };
      };

      filePanel = {
        listingStyle = mkStr "tree" ''
          One of 'list' or 'tree'
        '';

        treeOptions = let
          commonDesc = "Only applies when listing_style is 'tree'";
        in {
          flattenDirs = mkBool true ''
            Flatten dirs that only contain one single dir
            ${commonDesc}
          '';

          folderStatuses = mkStr "only_folded" ''
            One of 'never', 'only_folded' or 'always'.
            ${commonDesc}
          '';
        };
        winConfig = let
          commonDesc = "See ':h diffview-config-win_config'";
        in {
          position = mkStr "left" commonDesc;

          width = mkInt 35 commonDesc;

          winOpts = mkAttributeSet commonDesc;
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
            singleFile = mkAttributeSet commonDesc;

            multiFile = mkAttributeSet commonDesc;
          };
        };
        winConfig = let
          commonDesc = "See ':h diffview-config-win_config'";
        in {
          position = mkStr "bottom" commonDesc;

          height = mkInt 16 commonDesc;

          winOpts = mkAttributeSet commonDesc;
        };
      };

      commitLogPanel = {
        winConfig = {
          winOpts = mkAttributeSet ''
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

      hooks = mkAttributeSet ''
        See ':h diffview-config-hooks'
      '';

      keymaps = mkAttributeSet ''
          See documentation :help diffview-config-keymaps

          Example:

        keymaps = {
          view = [
            [
              [ "n" ]
              "<tab>"
              "actions.select_next_entry"
              { desc = "Open the diff for the next file"; }
            ]
          ];
        };
      '';

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

      inherit hooks;
      keymaps =
        if keymaps == null
        then {}
        else
          keymaps
          // {disable_defaults = disableDefaultKeymaps;};
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
