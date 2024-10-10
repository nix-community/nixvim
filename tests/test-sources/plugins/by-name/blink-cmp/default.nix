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
          show = "<C-space>";
          hide = "<C-e>";
          accept = "<Tab>";
          select_prev = "<C-p>";
          select_next = "<C-n>";
          show_documentation = "<C-space>";
          hide_documentation = "<C-space>";
          scroll_documentation_up = "<C-b>";
          scroll_documentation_down = "<C-f>";
          snippet_forward = "<Tab>";
          snippet_backward = "<S-Tab>";
        };
        highlight = {
          use_nvim_cmp_as_default = false;
        };
        nerd_font_variant = "normal";
        documentation = {
          auto_show = false;
          auto_show_delay_ms = 500;
          update_delay_ms = 50;
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
}
