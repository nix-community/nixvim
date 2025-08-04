{
  empty = {
    plugins.faster.enable = true;
  };

  defaults = {
    plugins.faster = {
      enable = true;
      settings = {
        behaviours = {
          bigfile = {
            on = true;
            features_disabled = [
              "illuminate"
              "matchparen"
              "lsp"
              "treesitter"
              "indent_blankline"
              "vimopts"
              "syntax"
              "filetype"
            ];
            filesize = 2;
            pattern = "*";
            extra_patterns = [ ];
          };
          fastmacro = {
            on = true;
            features_disabled = [ "lualine" ];
          };
          features = {
            filetype = {
              on = true;
              defer = true;
            };
            illuminate = {
              on = true;
              defer = false;
            };
            indent_blankline = {
              on = true;
              defer = false;
            };
            lsp = {
              on = true;
              defer = false;
            };
            lualine = {
              on = true;
              defer = false;
            };
            matchparen = {
              on = true;
              defer = false;
            };
            syntax = {
              on = true;
              defer = true;
            };
            treesitter = {
              on = true;
              defer = false;
            };
            vimopts = {
              on = true;
              defer = false;
            };
          };
        };
      };
    };
  };

  example = {
    plugins.faster = {
      enable = true;
      settings = {
        behaviours = {
          bigfile = {
            on = true;
            features_disabled = [
              "lsp"
              "treesitter"
            ];
            filesize = 2;
            pattern = "*";
            extra_patterns = [
              {
                filesize = 1.1;
                pattern = "*.md";
              }
              { pattern = "*.log"; }
            ];
          };
          fastmacro = {
            on = true;
            features_disabled = [ "lualine" ];
          };
        };
        features = {
          lsp = {
            on = true;
            defer = false;
          };
          treesitter = {
            on = true;
            defer = false;
          };
        };
      };
    };
  };
}
