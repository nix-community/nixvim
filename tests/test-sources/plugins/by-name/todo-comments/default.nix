{ lib, ... }:
{
  empty = {
    plugins.todo-comments.enable = true;
  };

  defaults = {
    plugins.todo-comments = {
      enable = true;

      settings = {
        signs = true;
        sign_priority = 8;

        keywords = {
          FIX = {
            icon = " ";
            color = "error";
            alt = [
              "FIXME"
              "BUG"
              "FIXIT"
              "ISSUE"
            ];
            signs = false;
          };
          TODO = {
            icon = " ";
            color = "info";
          };
          HACK = {
            icon = " ";
            color = "warning";
          };
          WARN = {
            icon = " ";
            color = "warning";
            alt = [
              "WARNING"
              "XXX"
            ];
          };
          PERF = {
            icon = " ";
            alt = [
              "OPTIM"
              "PERFORMANCE"
              "OPTIMIZE"
            ];
          };
          NOTE = {
            icon = " ";
            color = "hint";
            alt = [ "INFO" ];
          };
          TEST = {
            icon = "⏲ ";
            color = "test";
            alt = [
              "TESTING"
              "PASSED"
              "FAILED"
            ];
          };
        };

        gui_style = {
          fg = "NONE";
          bg = "BOLD";
        };

        merge_keywords = true;

        highlight = {
          multiline = true;
          multiline_pattern = "^.";
          multiline_context = 10;
          before = "";
          keyword = "wide";
          after = "fg";
          pattern = ''.*<(KEYWORDS)\s*:'';
          comments_only = true;
          max_line_len = 400;
          exclude = [ ];
        };

        colors = {
          error = [
            "DiagnosticError"
            "ErrorMsg"
            "#DC2626"
          ];
          warning = [
            "DiagnosticWarn"
            "WarningMsg"
            "#FBBF24"
          ];
          info = [
            "DiagnosticInfo"
            "#2563EB"
          ];
          hint = [
            "DiagnosticHint"
            "#10B981"
          ];
          default = [
            "Identifier"
            "#7C3AED"
          ];
          test = [
            "Identifier"
            "#FF00FF"
          ];
        };

        search = {
          command = "rg";
          args = [
            "--color=never"
            "--no-heading"
            "--with-filename"
            "--line-number"
            "--column"
          ];
          pattern = ''\b(KEYWORDS):'';
        };
      };
    };
  };

  keymaps-options = {
    plugins = {
      trouble.enable = true;
      telescope.enable = true;

      todo-comments = {
        enable = true;

        keymaps = {
          todoQuickFix.key = "<C-a>";
          todoLocList = {
            key = "<C-f>";
            cwd = "~/projects/foobar";
            keywords = [
              "TODO"
              "FIX"
            ];
            options.silent = true;
          };
          todoTrouble = {
            key = "<C-f>";
            keywords = [
              "TODO"
              "FIX"
            ];
            options = {
              desc = "Description for todoTrouble";
              silent = true;
            };
          };
          todoTelescope = {
            key = "<C-e>";
            cwd = "~/projects/foobar";
          };
        };
      };
      web-devicons.enable = true;
    };
  };

  conditional-mappings =
    { config, ... }:
    {
      plugins.telescope.enable = true;
      plugins.todo-comments = {
        enable = true;

        keymaps = {
          todoTrouble.key = lib.mkIf config.plugins.trouble.enable "<leader>xq";
          todoTelescope = lib.mkIf config.plugins.telescope.enable {
            key = "<leader>ft";
            keywords = [
              "TODO"
              "FIX"
              "FIX"
            ];
          };
        };
      };
      plugins.web-devicons.enable = true;
    };

  without-ripgrep = {
    plugins.todo-comments = {
      enable = true;

      ripgrepPackage = null;
    };
  };

  highlight-pattern-list = {
    plugins.todo-comments = {
      enable = true;

      settings = {
        highlight = {
          pattern = [ ".*<(KEYWORDS)\s*:" ];
        };
      };
    };
  };
}
