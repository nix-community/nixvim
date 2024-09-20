{
  empty = {
    plugins.chadtree.enable = true;
  };

  example = {
    plugins = {
      web-devicons.enable = true;
      chadtree = {
        enable = true;

        options = {
          follow = true;
          mimetypes = {
            warn = [
              "audio"
              "font"
              "image"
              "video"
            ];
            allowExts = [ ".ts" ];
          };
          pageIncrement = 5;
          pollingRate = 2.0;
          session = true;
          showHidden = false;
          versionControl = true;
          ignore = {
            nameExact = [
              ".DS_Store"
              ".directory"
              "thumbs.db"
              ".git"
            ];
            nameGlob = [ ];
            pathGlob = [ ];
          };
        };
        view = {
          openDirection = "left";
          sortBy = [
            "is_folder"
            "ext"
            "file_name"
          ];
          width = 40;
          windowOptions = {
            cursorline = true;
            number = false;
            relativenumber = false;
            signcolumn = "no";
            winfixwidth = true;
            wrap = false;
          };
        };
        theme = {
          highlights = {
            ignored = "Comment";
            bookmarks = "Title";
            quickfix = "Label";
            versionControl = "Comment";
          };
          iconGlyphSet = "devicons";
          textColourSet = "env";
          iconColourSet = "github";
        };
        keymap = {
          windowManagement = {
            quit = [ "q" ];
            bigger = [
              "+"
              "="
            ];
            smaller = [
              "-"
              "_"
            ];
            refresh = [ "<c-r>" ];
          };
          rerooting = {
            changeDir = [ "b" ];
            changeFocus = [ "c" ];
            changeFocusUp = [ "C" ];
          };
          openFileFolder = {
            primary = [ "<enter>" ];
            secondary = [
              "<tab>"
              "<2-leftmouse>"
            ];
            tertiary = [
              "<m-enter>"
              "<middlemouse>"
            ];
            vSplit = [ "w" ];
            hSplit = [ "W" ];
            openSys = [ "o" ];
            collapse = [ "o" ];
          };
          cursor = {
            refocus = [ "~" ];
            jumpToCurrent = [ "J" ];
            stat = [ "K" ];
            copyName = [ "y" ];
            copyBasename = [ "Y" ];
            copyRelname = [ "<c-y>" ];
          };
          filtering = {
            filter = [ "f" ];
            clearFilter = [ "F" ];
          };
          bookmarks = {
            bookmarkGoto = [ "m" ];
          };
          selecting = {
            select = [ "s" ];
            clearSelection = [ "S" ];
          };
          fileOperations = {
            new = [ "a" ];
            link = [ "A" ];
            rename = [ "r" ];
            toggleExec = [ "X" ];
            copy = [ "p" ];
            cut = [ "x" ];
            delete = [ "d" ];
            trash = [ "t" ];
          };
          toggles = {
            toggleHidden = [ "." ];
            toggleFollow = [ "u" ];
            toggleVersionControl = [ "i" ];
          };
        };
      };
    };
  };

  no-icons = {
    plugins.web-devicons.enable = false;
    plugins.chadtree = {
      enable = true;
    };
  };
}
