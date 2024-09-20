{
  empty = {
    plugins.fidget.enable = true;
  };

  defaults = {
    plugins.fidget = {
      enable = true;

      progress = {
        pollRate = 0;
        suppressOnInsert = false;
        ignoreDoneAlready = false;
        ignoreEmptyMessage = true;
        notificationGroup = "function(msg) return msg.lsp_name end";
        clearOnDetach = ''
          function(client_id)
            local client = vim.lsp.get_client_by_id(client_id)
            return client and client.name or nil
          end
        '';
        ignore = [ ];
        display = {
          renderLimit = 16;
          doneTtl = 3;
          doneIcon = "✔";
          doneStyle = "Constant";
          progressTtl = "math.huge";
          progressIcon = {
            pattern = "dots";
          };
          progressStyle = "WarningMsg";
          groupStyle = "Title";
          iconStyle = "Question";
          priority = 30;
          skipHistory = true;
          formatMessage = "require('fidget.progress.display').default_format_message";
          formatAnnote = "function(msg) return msg.title end";
          formatGroupName = "function(group) return tostring(group) end";
          overrides = {
            rust_analyzer = {
              name = "rust-analyzer";
            };
          };
        };
        lsp = {
          progressRingbufSize = 0;
        };
      };
      notification = {
        pollRate = 10;
        filter = "info";
        historySize = 128;
        overrideVimNotify = false;
        configs = {
          default = "require('fidget.notification').default_config";
        };
        redirect = ''
          function(msg, level, opts)
            if opts and opts.on_open then
              return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
            end
          end
        '';
        view = {
          stackUpwards = true;
          iconSeparator = " ";
          groupSeparator = "---";
          groupSeparatorHl = "Comment";
        };
        window = {
          normalHl = "Comment";
          winblend = 100;
          border = "none";
          borderHl = "";
          zindex = 45;
          maxWidth = 0;
          maxHeight = 0;
          xPadding = 1;
          yPadding = 0;
          align = "bottom";
          relative = "editor";
        };
      };
      integration = {
        nvim-tree = {
          enable = false;
        };
      };
      logger = {
        level = "warn";
        floatPrecision = 1.0e-2;
        path.__raw = "string.format('%s/fidget.nvim.log', vim.fn.stdpath('cache'))";
      };
    };
  };

  nvim-tree-integration = {
    plugins = {
      nvim-tree.enable = true;
      fidget = {
        enable = true;
        integration = {
          nvim-tree.enable = true;
        };
      };
      web-devicons.enable = true;
    };
  };
}
