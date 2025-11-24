{ lib }:
{
  empty = {
    plugins.tiny-inline-diagnostic.enable = true;
  };

  defaults = {
    plugins.tiny-inline-diagnostic = {
      enable = true;

      settings = {
        preset = "classic";
        virt_texts = {
          priority = 2048;
        };
        multilines = {
          enabled = true;
        };
        options = {
          use_icons_from_diagnostic = true;
        };
      };
    };
  };

  example = {
    plugins.tiny-inline-diagnostic = {
      enable = true;

      settings = {
        preset = "modern";
        transparent_bg = false;
        transparent_cursorline = false;
        hi = {
          error = "DiagnosticError";
          warn = "DiagnosticWarn";
          info = "DiagnosticInfo";
          hint = "DiagnosticHint";
          arrow = "NonText";
          background = "CursorLine";
          mixing_color = "None";
        };
        options = {
          show_source = {
            enabled = false;
            if_many = false;
          };
          use_icons_from_diagnostic = false;
          set_arrow_to_diag_color = false;
          add_messages = true;
          throttle = 20;
          softwrap = 30;
          multilines = {
            enabled = false;
            always_show = false;
          };
          show_all_diags_on_cursorline = false;
          enable_on_insert = false;
          enable_on_select = false;

          overflow = {
            mode = "wrap";
            padding = 0;
          };
          break_line = {
            enabled = false;
            after = 30;
          };
          format.__raw = "nil";
          virt_texts = {
            priority = 2048;
          };
          severity = [
            (lib.nixvim.mkRaw "vim.diagnostic.severity.ERROR")
            (lib.nixvim.mkRaw "vim.diagnostic.severity.WARN")
            (lib.nixvim.mkRaw "vim.diagnostic.severity.INFO")
            (lib.nixvim.mkRaw "vim.diagnostic.severity.HINT")
          ];
          overwrite_events.__raw = "nil";
        };
        disabled_ft.__empty = { };
      };
    };
  };
}
