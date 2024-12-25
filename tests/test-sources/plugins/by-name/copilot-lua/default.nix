{
  empty = {
    plugins.copilot-lua.enable = true;
  };

  nvim-cmp = {
    plugins = {
      copilot-lua = {
        enable = true;

        settings = {
          panel.enabled = false;
          suggestion.enabled = false;
        };
      };

      copilot-cmp.settings = {
        event = [
          "InsertEnter"
          "LspAttach"
        ];
        fix_pairs = true;
      };

      cmp = {
        enable = true;
        settings.sources = [ { name = "copilot"; } ];
      };
    };
  };

  default = {
    plugins.copilot-lua = {
      enable = true;

      settings = {
        panel = {
          enabled = true;
          auto_refresh = false;
          keymap = {
            jump_prev = "[[";
            jump_next = "]]";
            accept = "<CR>";
            refresh = "gr";
            open = "<M-CR>";
          };
          layout = {
            position = "bottom";
            ratio = 0.4;
          };
        };
        suggestion = {
          enabled = true;
          auto_trigger = false;
          hide_during_completion = true;
          debounce = 75;
          keymap = {
            accept = "<M-l>";
            accept_word = false;
            accept_line = false;
            next = "<M-]>";
            prev = "<M-[>";
            dismiss = "<C-]>";
          };
        };
        filetypes = {
          yaml = false;
          markdown = false;
          help = false;
          gitcommit = false;
          gitrebase = false;
          hgcommit = false;
          svn = false;
          cvs = false;
          "." = false;
        };
        server_opts_overrides = {
          trace = "verbose";
          settings = {
            advanced = {
              listCount = 10; # number of completions for panel
              inlineSuggestCount = 3; # number of completions for getCompletions
            };
          };
        };
      };
    };
  };

  examples = {
    plugins.copilot-lua = {
      enable = true;

      settings = {
        panel = {
          enabled = true;
          auto_refresh = true;
          keymap = {
            jump_prev = "[[";
            jump_next = "]]";
            accept = "<CR>";
            refresh = "gr";
            open = "<M-CR>";
          };
          layout = {
            position = "top";
            ratio = 0.5;
          };
        };
        suggestion = {
          enabled = true;
          auto_trigger = false;
          hide_during_completion = false;
          debounce = 90;
          keymap = {
            accept = "<M-l>";
            accept_word = false;
            accept_line = false;
            next = "<M-]>";
            prev = "<M-[>";
            dismiss = "<C-]>";
          };
        };
        filetypes = {
          yaml = true;
          markdown = true;
          help = true;
          gitcommit = true;
          gitrebase = true;
          hgcommit = true;
          svn = true;
          cvs = true;
          "." = true;
        };
        server_opts_overrides = {
          trace = "verbose";
          settings = {
            advanced = {
              listCount = 10; # number of completions for panel
              inlineSuggestCount = 3; # number of completions for getCompletions
            };
          };
        };
      };
    };
  };
}
