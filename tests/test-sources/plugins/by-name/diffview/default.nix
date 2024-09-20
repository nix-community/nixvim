{
  empty = {
    plugins.web-devicons.enable = true;
    plugins.diffview.enable = true;
  };

  example = {
    plugins.web-devicons.enable = true;
    plugins.diffview = {
      enable = true;

      diffBinaries = true;
      enhancedDiffHl = true;
      gitCmd = [ "git" ];
      hgCmd = [ "hg" ];
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
          winOpts = { };
        };
      };
      fileHistoryPanel = {
        logOptions = {
          git = {
            singleFile = {
              base = "a";
              diffMerges = "combined";
            };
            multiFile.diffMerges = "first-parent";
          };
          hg = {
            singleFile = { };
            multiFile = { };
          };
        };
        winConfig = {
          position = "top";
          height = 10;
          winOpts = { };
        };
      };

      commitLogPanel.winConfig.winOpts = { };
      defaultArgs = {
        diffviewOpen = [ "HEAD" ];
        diffviewFileHistory = [ "%" ];
      };
      hooks = {
        viewOpened = ''
          function(view)
            print(
              ("A new %s was opened on tab page %d!")
              :format(view.class:name(), view.tabpage)
            )
          end
        '';
      };
      keymaps = {
        view = [
          {
            mode = "n";
            key = "<tab>";
            action = "actions.select_next_entry";
            description = "Open the diff for the next file";
          }
        ];
        diff1 = [
          {
            mode = "n";
            key = "<tab>";
            action = "actions.select_next_entry";
          }
        ];
        diff2 = [
          {
            mode = "n";
            key = "<tab>";
            action = "actions.select_next_entry";
            description = "Open the diff for the next file";
          }
        ];
        diff3 = [
          {
            mode = "n";
            key = "<tab>";
            action = "actions.select_next_entry";
            description = "Open the diff for the next file";
          }
        ];
        diff4 = [
          {
            mode = "n";
            key = "<tab>";
            action = "actions.select_next_entry";
            description = "Open the diff for the next file";
          }
        ];
        filePanel = [
          {
            mode = "n";
            key = "<tab>";
            action = "actions.select_next_entry";
            description = "Open the diff for the next file";
          }
        ];
        fileHistoryPanel = [
          {
            mode = "n";
            key = "<tab>";
            action = "actions.select_next_entry";
            description = "Open the diff for the next file";
          }
        ];
        optionPanel = [
          {
            mode = "n";
            key = "<tab>";
            action = "actions.select_next_entry";
            description = "Open the diff for the next file";
          }
        ];
        helpPanel = [
          {
            mode = "n";
            key = "<tab>";
            action = "actions.select_next_entry";
            description = "Open the diff for the next file";
          }
        ];
      };
    };
  };

  no-icons = {
    plugins.web-devicons.enable = false;
    plugins.diffview = {
      enable = true;
    };
  };
}
