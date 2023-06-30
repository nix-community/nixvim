{
  empty = {
    plugins.diffview.enable = true;
  };

  example = {
    plugins.diffview = {
      enable = true;

      diffBinaries = true;
      enhancedDiffHl = true;
      gitCmd = ["git"];
      hgCmd = ["hg"];
      useIcons = false;
      showHelpHints = false;
      watchIndex = true;
      icons = {
        folderClosed = "a";
        folderOpen = "b";
      };
      signs = {
        foldClosed = "c";
        foldOpen = "d";
        done = "e";
      };
      view = {
        default = {
          layout = "diff2_horizontal";
          winbarInfo = true;
        };
        mergeTool = {
          layout = "diff1_plain";
          disableDiagnostics = false;
          winbarInfo = false;
        };
        fileHistory = {
          layout = "diff2_vertical";
          winbarInfo = true;
        };
      };
      filePanel = {
        listingStyle = "list";
        treeOptions = {
          flattenDirs = false;
          folderStatuses = "never";
        };
        winConfig = {
          position = "right";
          width = 20;
          winOpts = {};
        };
      };
      fileHistoryPanel = {
        logOptions = {
          git = {
            singleFile.diffMerges = "combined";
            multiFile.diffMerges = "first-parent";
          };
          hg = {
            singleFile = {};
            multiFile = {};
          };
        };
        winConfig = {
          position = "top";
          height = 10;
          winOpts = {};
        };
      };

      commitLogPanel.winConfig.winOpts = {};
      defaultArgs = {
        diffviewOpen = ["HEAD"];
        diffviewFileHistory = ["%"];
      };
      hooks = {};
      keymaps = {
        view = [
          [
            ["n"]
            "<tab>"
            "actions.select_next_entry"
            {desc = "Open the diff for the next file";}
          ]
        ];
      };
      disableDefaultKeymaps = true;
    };
  };
}
