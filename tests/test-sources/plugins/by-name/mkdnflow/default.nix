{
  empty = {
    plugins.mkdnflow.enable = true;
  };

  example = {
    plugins.mkdnflow = {
      enable = true;

      settings = {
        modules = {
          bib = true;
          buffers = true;
          conceal = true;
          cursor = true;
          folds = true;
          links = true;
          lists = true;
          maps = true;
          paths = true;
          tables = true;
          yaml = false;
        };
        filetypes = {
          md = true;
          rmd = true;
          markdown = true;
        };
        create_dirs = true;
        perspective = {
          priority = "first";
          fallback = "first";
          root_tell = false;
          nvim_wd_heel = false;
          update = true;
        };
        wrap = false;
        bib = {
          default_path.__raw = "nil";
          find_in_root = true;
        };
        silent = false;
        links = {
          style = "markdown";
          conceal = false;
          context = 0;
          implicit_extension.__raw = "nil";
          transform_explicit = false;
          transform_implicit = ''
            function(text)
                text = text:gsub(" ", "-")
                text = text:lower()
                text = os.date('%Y-%m-%d_')..text
                return(text)
            end
          '';
        };
        to_do = {
          symbols = [
            " "
            "-"
            "X"
          ];
          update_parents = true;
          not_started = " ";
          in_progress = "-";
          complete = "X";
        };
        tables = {
          trim_whitespace = true;
          format_on_move = true;
          auto_extend_rows = false;
          auto_extend_cols = false;
        };
        yaml = {
          bib = {
            override = false;
          };
        };
        mappings = {
          MkdnEnter = {
            modes = [
              "n"
              "v"
              "i"
            ];
            key = "<CR>";
          };
          MkdnTab = false;
          MkdnSTab = false;
          MkdnNextLink = {
            modes = "n";
            key = "<Tab>";
          };
          MkdnPrevLink = {
            modes = "n";
            key = "<S-Tab>";
          };
          MkdnNextHeading = {
            modes = "n";
            key = "]]";
          };
          MkdnPrevHeading = {
            modes = "n";
            key = "[[";
          };
          MkdnGoBack = {
            modes = "n";
            key = "<BS>";
          };
          MkdnGoForward = {
            modes = "n";
            key = "<Del>";
          };
          MkdnFollowLink = false;
          MkdnCreateLink = false;
          MkdnCreateLinkFromClipboard = {
            modes = [
              "n"
              "v"
            ];
            key = "<leader>p";
          };
          MkdnDestroyLink = {
            modes = "n";
            key = "<M-CR>";
          };
          MkdnMoveSource = {
            modes = "n";
            key = "<F2>";
          };
          MkdnYankAnchorLink = {
            modes = "n";
            key = "ya";
          };
          MkdnYankFileAnchorLink = {
            modes = "n";
            key = "yfa";
          };
          MkdnIncreaseHeading = {
            modes = "n";
            key = "+";
          };
          MkdnDecreaseHeading = {
            modes = "n";
            key = "-";
          };
          MkdnToggleToDo = {
            modes = [
              "n"
              "v"
            ];
            key = "<C-Space>";
          };
          MkdnNewListItem = false;
          MkdnNewListItemBelowInsert = {
            modes = "n";
            key = "o";
          };
          MkdnNewListItemAboveInsert = {
            modes = "n";
            key = "O";
          };
          MkdnExtendList = false;
          MkdnUpdateNumbering = {
            modes = "n";
            key = "<leader>nn";
          };
          MkdnTableNextCell = {
            modes = "i";
            key = "<Tab>";
          };
          MkdnTablePrevCell = {
            modes = "i";
            key = "<S-Tab>";
          };
          MkdnTableNextRow = false;
          MkdnTablePrevRow = {
            modes = "i";
            key = "<M-CR>";
          };
          MkdnTableNewRowBelow = {
            modes = "n";
            key = "<leader>ir";
          };
          MkdnTableNewRowAbove = {
            modes = "n";
            key = "<leader>iR";
          };
          MkdnTableNewColAfter = {
            modes = "n";
            key = "<leader>ic";
          };
          MkdnTableNewColBefore = {
            modes = "n";
            key = "<leader>iC";
          };
          MkdnFoldSection = {
            modes = "n";
            key = "<leader>f";
          };
          MkdnUnfoldSection = {
            modes = "n";
            key = "<leader>F";
          };
        };
      };
    };
  };
}
