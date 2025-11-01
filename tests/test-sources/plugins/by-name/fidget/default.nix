{
  empty = {
    plugins.fidget.enable = true;
  };

  defaults = {
    plugins.fidget = {
      enable = true;

      settings = {
        progress = {
          poll_rate = 0;
          suppress_on_insert = false;
          ignore_done_already = false;
          ignore_empty_message = true;
          notification_group.__raw = "function(msg) return msg.lsp_name end";
          clear_on_detach.__raw = ''
            function(client_id)
              local client = vim.lsp.get_client_by_id(client_id)
              return client and client.name or nil
            end
          '';
          ignore.__empty = { };
          display = {
            render_limit = 16;
            done_ttl = 3;
            done_icon = "✔";
            done_style = "Constant";
            progress_ttl.__raw = "math.huge";
            progress_icon = [ "dots" ];
            progress_style = "Warning_msg";
            group_style = "Title";
            icon_style = "Question";
            priority = 30;
            skip_history = true;
            format_message.__raw = "require('fidget.progress.display').default_format_message";
            format_annote.__raw = "function(msg) return msg.title end";
            format_group_name.__raw = "function(group) return tostring(group) end";
            overrides = {
              rust_analyzer = {
                name = "rust-analyzer";
              };
            };
          };
          lsp = {
            progress_ringbuf_size = 0;
          };
        };
        notification = {
          poll_rate = 10;
          filter = "info";
          history_size = 128;
          override_vim_notify = false;
          configs = {
            default.__raw = "require('fidget.notification').default_config";
          };
          redirect.__raw = ''
            function(msg, level, opts)
              if opts and opts.on_open then
                return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
              end
            end
          '';
          view = {
            stack_upwards = true;
            icon_separator = " ";
            group_separator = "---";
            group_separator_hl = "Comment";
          };
          window = {
            normal_hl = "Comment";
            winblend = 100;
            border = "none";
            border_hl = "";
            zindex = 45;
            max_width = 0;
            max_height = 0;
            x_padding = 1;
            y_padding = 0;
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
          float_precision = 1.0e-2;
          path.__raw = "string.format('%s/fidget.nvim.log', vim.fn.stdpath('cache'))";
        };
      };
    };
  };

  nvim-tree-integration = {
    plugins = {
      nvim-tree.enable = true;
      fidget = {
        enable = true;
        settings = {
          integration = {
            nvim-tree.enable = true;
          };
        };
      };
      web-devicons.enable = true;
    };
  };
}
