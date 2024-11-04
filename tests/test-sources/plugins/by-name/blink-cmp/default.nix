{
  empty = {
    test.runNvim = false;
    plugins.blink-cmp.enable = true;
  };

  default = {
    test.runNvim = false;
    plugins.blink-cmp = {
      enable = true;
      settings = {
        keymap = {
          preset = "default";
        };
        highlight = {
          use_nvim_cmp_as_default = false;
        };
        nerd_font_variant = "normal";
        windows = {
          documentation = {
            auto_show = false;
            auto_show_delay_ms = 500;
            update_delay_ms = 50;
          };
        };
        accept = {
          auto_brackets = {
            enabled = false;
          };
        };
        trigger = {
          signature_help = {
            enabled = false;
            show_on_insert_on_trigger_character = false;
          };
        };
        fuzzy = {
          use_frecency = true;
          use_proximity = true;
          max_items = 200;
          prebuiltBinaries = {
            download = false;
          };
        };
        sources = {
          completion = {
            enabled_providers = [
              "lsp"
              "path"
              "snippets"
              "buffer"
            ];
          };
        };
      };
    };
  };

  example = {
    plugins.blink-cmp = {
      enable = true;
      settings = {
        fuzzy = {
          prebuilt_binaries = {
            download = false;
          };
        };
        keymap = {
          "<C-space>" = [
            "show"
            "show_documentation"
            "hide_documentation"
          ];
          "<C-e>" = [ "hide" ];
          "<C-y>" = [ "select_and_accept" ];

          "<Up>" = [
            "select_prev"
            "fallback"
          ];
          "<Down>" = [
            "select_next"
            "fallback"
          ];
          "<C-p>" = [
            "select_prev"
            "fallback"
          ];
          "<C-n>" = [
            "select_next"
            "fallback"
          ];

          "<C-b>" = [
            "scroll_documentation_up"
            "fallback"
          ];
          "<C-f>" = [
            "scroll_documentation_down"
            "fallback"
          ];

          "<Tab>" = [
            "snippet_forward"
            "fallback"
          ];
          "<S-Tab>" = [
            "snippet_backward"
            "fallback"
          ];
        };
        highlight = {
          use_nvim_cmp_as_default = true;
        };
        windows = {
          documentation = {
            auto_show = true;
          };
        };
        accept = {
          auto_brackets = {
            enabled = true;
          };
        };
        trigger = {
          signature_help = {
            enabled = true;
          };
        };
      };

    };
  };
}
