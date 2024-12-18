{
  empty = {
    plugins.copilot-lua.enable = true;
  };

  nvim-cmp = {
    plugins = {
      copilot-lua = {
        enable = true;

        panel.enabled = false;
        suggestion.enabled = false;
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

      panel = {
        enabled = true;
        autoRefresh = false;
        keymap = {
          jumpPrev = "[[";
          jumpNext = "]]";
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
        autoTrigger = false;
        debounce = 75;
        keymap = {
          accept = "<M-l>";
          acceptWord = false;
          acceptLine = false;
          next = "<M-]>";
          prev = "<M-[>";
          dismiss = "<C-]>";
        };
      };
      filetypes = {
        markdown = true;
        terraform = false;
        sh.__raw = ''
          function ()
            if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%.env.*') then
              -- disable for .env files
              return false
            end
            return true
          end
        '';
      };
      serverOptsOverrides = {
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
}
