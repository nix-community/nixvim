{
  empty = {
    # TODO 2025-10-01
    # Calls `require("lspconfig")` which is deprecated, producing a warning
    test.runNvim = false;

    plugins.lean.enable = true;
  };

  # Enable the `leanls` LSP directly from `plugins.lsp`. This implies explicitly disabling the lsp
  # in the `lean` plugin configuration.
  lspDisabled = {
    plugins = {
      lsp = {
        enable = true;

        # FIXME: 2025-11-26: Enabling `plugins.lsp.leanls` throws the following warning:
        # The option definition `plugins.lsp.servers.leanls' in ... no longer has any effect; please remove it.
        # nvim-lspconfig has switched from its own LSP configuration API to neovim's built-in LSP API.
        # 'leanls' has not been updated to support neovim's built-in LSP API.
        # servers.leanls.enable = true;
      };

      lean = {
        enable = true;
        settings.lsp.enable = false;
      };
    };
  };

  default = {
    # TODO 2025-10-01
    # Calls `require("lspconfig")` which is deprecated, producing a warning
    test.runNvim = false;

    plugins = {
      lsp.enable = true;

      lean = {
        enable = true;
        settings = {
          lsp.__empty = { };
          ft = {
            default = "lean";
            nomodifiable.__raw = "nil";
          };
          abbreviations = {
            enable = true;
            extra.__empty = { };
            leader = "\\";
          };
          mappings = false;
          infoview = {
            autoopen = true;
            autopause = false;
            width = 50;
            height = 20;
            horizontal_position = "bottom";
            separate_tab = false;
            indicators = "auto";
            show_processing = true;
            show_no_info_message = false;
            use_widgets = true;
            mappings = {
              K = "click";
              "<CR>" = "click";
              gd = "go_to_def";
              gD = "go_to_decl";
              gy = "go_to_type";
              I = "mouse_enter";
              i = "mouse_leave";
              "<Esc>" = "clear_all";
              C = "clear_all";
              "<LocalLeader><Tab>" = "goto_last_window";
            };
          };
          progress_bars = {
            enable = true;
            priority = 10;
          };
          stderr = {
            enable = true;
            height = 5;
            on_lines.__raw = "function(lines) vim.notify(lines) end";
          };
        };
      };
    };
  };
}
