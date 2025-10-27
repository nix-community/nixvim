{
  empty = {
    plugins.indent-blankline.enable = true;
  };

  example = {
    plugins.indent-blankline = {
      enable = true;

      settings = {
        indent = {
          char = "│";
        };
        scope = {
          show_start = false;
          show_end = false;
          show_exact_scope = true;
        };
        exclude = {
          filetypes = [
            ""
            "checkhealth"
            "help"
            "lspinfo"
            "packer"
            "TelescopePrompt"
            "TelescopeResults"
            "yaml"
          ];
          buftypes = [
            "terminal"
            "quickfix"
          ];
        };
      };
    };
  };

  defaults = {
    plugins.indent-blankline = {
      enable = true;

      settings = {
        debounce = 200;
        viewport_buffer = {
          min = 30;
          max = 500;
        };
        indent = {
          char = "▎";
          tab_char.__raw = "nil";
          highlight.__raw = "nil";
          smart_indent_cap = true;
          priority = 1;
        };
        whitespace = {
          highlight.__raw = "nil";
          remove_blankline_trail = true;
        };
        scope = {
          enabled = true;
          char.__raw = "nil";
          show_start = true;
          show_end = true;
          show_exact_scope = false;
          injected_languages = true;
          highlight.__raw = "nil";
          priority = 1024;
          include = {
            node_type.__empty = { };
          };
          exclude = {
            language.__empty = { };
            node_type = {
              "*" = [
                "source_file"
                "program"
              ];
              lua = [ "chunk" ];
              python = [ "module" ];
            };
          };
        };
        exclude = {
          filetypes = [
            "lspinfo"
            "packer"
            "checkhealth"
            "help"
            "man"
            "gitcommit"
            "TelescopePrompt"
            "TelescopeResults"
            "\'\'"
          ];
          buftypes = [
            "terminal"
            "nofile"
            "quickfix"
            "prompt"
          ];
        };
      };
    };
  };
}
