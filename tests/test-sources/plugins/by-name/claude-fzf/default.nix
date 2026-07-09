{
  empty = {
    plugins = {
      fzf-lua.enable = true;
      claudecode = {
        enable = true;
        # The default starts a WebSocket server, then logs an INFO shutdown message on VimLeavePre.
        # Nixvim's headless test runner treats any stderr output as a failure.
        settings.auto_start = false;
      };
      claude-fzf = {
        enable = true;
        # The default logs an INFO message via `vim.notify` on setup.
        # Nixvim's headless test runner treats any stderr output as a failure.
        settings.logging.level = "WARN";
      };
    };
  };

  defaults = {
    plugins = {
      fzf-lua.enable = true;
      claudecode = {
        enable = true;
        # See `empty` above.
        settings.auto_start = false;
      };

      claude-fzf = {
        enable = true;
        settings = {
          batch_size = 5;
          show_progress = true;
          auto_open_terminal = true;
          auto_context = true;

          notifications = {
            enabled = true;
            show_progress = true;
            show_success = true;
            show_errors = true;
            use_snacks = true;
            timeout = 3000;
          };

          logging = {
            # See `empty` above; the documented default is "INFO".
            level = "WARN";
            file_logging = true;
            console_logging = true;
            show_caller = true;
            timestamp = true;
          };

          # Keymaps are disabled by default; users must explicitly configure them.
          keymaps = {
            files = "";
            grep = "";
            buffers = "";
            git_files = "";
            directory_files = "";
          };

          fzf_opts = {
            preview = {
              border = "sharp";
              title = "Preview";
              wrap = "wrap";
            };
            winopts = {
              height = 0.99;
              width = 0.99;
              backdrop = 60;
            };
          };

          claude_opts = {
            auto_open_terminal = true;
            context_lines = 5;
            source_tag = "claude-fzf";
          };

          directory_search = {
            directories.__empty = { };
            default_extensions = [ ];
          };

          picker_opts = {
            files = {
              prompt = "Add to Claude> ";
              header = "Select files/directories to add to Claude context. Tab to multi-select, Enter to confirm.";
            };
            grep = {
              prompt = "Claude Grep> ";
              header = "Search and select results to add to Claude. Tab to multi-select, Enter to confirm.";
            };
            buffers = {
              prompt = "Claude Buffers> ";
              header = "Select buffers to add to Claude. Tab to multi-select, Enter to confirm.";
            };
            git_files = {
              prompt = "Claude Git Files> ";
              header = "Select Git files to add to Claude. Tab to multi-select, Enter to confirm.";
            };
            directory_files = {
              prompt = "Claude Directory> ";
              header = "Select files from directory to add to Claude. Tab to multi-select, Enter to confirm.";
            };
          };
        };
      };
    };
  };

  example = {
    plugins = {
      fzf-lua.enable = true;
      claudecode = {
        enable = true;
        # See `empty` above.
        settings.auto_start = false;
      };

      claude-fzf = {
        enable = true;
        settings = {
          batch_size = 10;
          keymaps = {
            files = "<leader>acF";
            grep = "<leader>acg";
            buffers = "<leader>acB";
            git_files = "<leader>acG";
            directory_files = "<leader>acD";
          };
          fzf_opts = {
            preview = {
              border = "rounded";
            };
            winopts = {
              width = 0.7;
            };
          };
          # See `empty` above.
          logging.level = "WARN";
        };
      };
    };
  };
}
