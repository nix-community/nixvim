{
  empty = {
    plugins.fzf-lua.enable = true;

    plugins.claude-fzf-history = {
      enable = true;
      # The default logs an INFO message via `vim.notify` on setup.
      # Nixvim's headless test runner treats any stderr output as a failure.
      settings.logging.level = "WARN";
    };
  };

  defaults = {
    plugins.fzf-lua.enable = true;

    plugins.claude-fzf-history = {
      enable = true;
      settings = {
        history = {
          max_items = 1000;
          min_item_length = 10;
          cache_timeout = 300;
          auto_refresh = true;
        };

        logging = {
          # See `empty` above; the documented default is "INFO".
          level = "WARN";
          file_logging = false;
          console_logging = true;
          show_caller = true;
          timestamp = true;
        };

        display = {
          max_question_length = 80;
          show_timestamp = true;
          show_line_numbers = true;
          date_format = "%Y-%m-%d %H:%M";
        };

        fzf_opts = {
          "--multi" = true;
          "--ansi" = "";
          "--info" = "inline";
          "--height" = "100%";
          "--layout" = "reverse";
          "--border" = "none";
          silent = true;
          winopts = {
            height = 0.7;
            width = 0.8;
            row = 0.35;
            col = 0.50;
          };
        };

        preview = {
          enabled = true;
          hidden = false;
          position = "right:60%";
          wrap = true;
          toggle_key = "ctrl-/";
          scroll_up = "shift-up";
          scroll_down = "shift-down";
          type = "external";
          syntax_highlighting = {
            enabled = true;
            fallback = true;
            theme = "Monokai Extended Bright";
            language = "markdown";
            show_line_numbers = true;
          };
        };

        keymap = {
          fzf = {
            tab = "toggle";
          };
        };

        # No default keybinding, to avoid conflicts.
        keymaps.history = null;

        parser = {
          patterns = {
            question_start = "^>%s*(.+)$";
            answer_start = "^Claude:";
            answer_continuation = "^%s*(.+)$";
          };
          ignore_patterns = [
            "^%s*$"
            "^%-%-%-+$"
            "^%[%d+%-%d+%-%d+"
          ];
        };

        actions = {
          jump_to_qa = "default";
          export_qa = "ctrl-e";
          search_qa = "ctrl-/";
          filter_qa = "ctrl-f";
        };
      };
    };
  };

  example = {
    plugins.fzf-lua.enable = true;

    plugins.claude-fzf-history = {
      enable = true;
      settings = {
        keymaps = {
          history = "<leader>ch";
        };
        preview = {
          position = "right:60%";
          wrap = true;
          syntax_highlighting = {
            theme = "Catppuccin Macchiato";
            language = "markdown";
            show_line_numbers = false;
          };
        };
        # See `empty` above.
        logging.level = "WARN";
      };
    };
  };
}
