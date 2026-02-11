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
          statuses = [
            {
              name = "not_started";
              marker = " ";
              highlight = {
                marker.link = "Conceal";
                content.link = "Conceal";
              };
              sort = {
                section = 2;
                position = "top";
              };
              skip_on_toggle = false;
            }
            {
              name = "in_progress";
              marker = "-";
              highlight = {
                marker.link = "WarningMsg";
                content.bold = true;
              };
              sort = {
                section = 1;
                position = "bottom";
              };
              skip_on_toggle = false;
            }
            {
              name = "complete";
              marker = [
                "X"
                "x"
              ];
              highlight = {
                marker.link = "String";
                content.link = "Conceal";
              };
              sort = {
                section = 3;
                position = "top";
              };
              skip_on_toggle = false;
            }
          ];
          status_propagation = {
            up = true;
            down = true;
          };
          sort = {
            on_status_change = false;
            recursive = false;
            cursor_behavior = {
              track = true;
            };
          };
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
          MkdnEnter = [
            [
              "n"
              "v"
              "i"
            ]
            "<CR>"
          ];
          MkdnTab = false;
          MkdnSTab = false;
          MkdnNextLink = [
            "n"
            "<Tab>"
          ];
          MkdnPrevLink = [
            "n"
            "<S-Tab>"
          ];
          MkdnNextHeading = [
            "n"
            "]]"
          ];
          MkdnPrevHeading = [
            "n"
            "[["
          ];
          MkdnGoBack = [
            "n"
            "<BS>"
          ];
          MkdnGoForward = [
            "n"
            "<Del>"
          ];
          MkdnFollowLink = false;
          MkdnCreateLink = false;
          MkdnCreateLinkFromClipboard = [
            [
              "n"
              "v"
            ]
            "<leader>p"
          ];
          MkdnDestroyLink = [
            "n"
            "<M-CR>"
          ];
          MkdnMoveSource = [
            "n"
            "<F2>"
          ];
          MkdnYankAnchorLink = [
            "n"
            "ya"
          ];
          MkdnYankFileAnchorLink = [
            "n"
            "yfa"
          ];
          MkdnIncreaseHeading = [
            "n"
            "+"
          ];
          MkdnDecreaseHeading = [
            "n"
            "-"
          ];
          MkdnToggleToDo = [
            [
              "n"
              "v"
            ]
            "<C-Space>"
          ];
          MkdnNewListItem = false;
          MkdnNewListItemBelowInsert = [
            "n"
            "o"
          ];
          MkdnNewListItemAboveInsert = [
            "n"
            "O"
          ];
          MkdnExtendList = false;
          MkdnUpdateNumbering = [
            "n"
            "<leader>nn"
          ];
          MkdnTableNextCell = [
            "i"
            "<Tab>"
          ];
          MkdnTablePrevCell = [
            "i"
            "<S-Tab>"
          ];
          MkdnTableNextRow = false;
          MkdnTablePrevRow = [
            "i"
            "<M-CR>"
          ];
          MkdnTableNewRowBelow = [
            "n"
            "<leader>ir"
          ];
          MkdnTableNewRowAbove = [
            "n"
            "<leader>iR"
          ];
          MkdnTableNewColAfter = [
            "n"
            "<leader>ic"
          ];
          MkdnTableNewColBefore = [
            "n"
            "<leader>iC"
          ];
          MkdnFoldSection = [
            "n"
            "<leader>f"
          ];
          MkdnUnfoldSection = [
            "n"
            "<leader>F"
          ];
        };
      };
    };

  };

  mappings-deprecated = {
    plugins.mkdnflow = {
      enable = true;
      settings = {
        mappings = {
          MkdnEnter = {
            modes = [
              "n"
              "i"
            ];
            key = "<CR>";
          };
        };
      };
    };

    test.runNvim = false;
  };
}
