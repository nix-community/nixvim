{
  empty = {
    plugins.flutter-tools.enable = true;
  };

  defaults = {
    plugins.flutter-tools = {
      enable = true;

      settings = {
        ui = {
          border = "single";
        };
        decorations = {
          statusline = {
            app_version = false;
            device = false;
            project_config = false;
          };
        };
        debugger = {
          enabled = false;
          exception_breakpoints.__raw = "nil";
          evaluate_to_string_in_debug_views = true;
          register_configurations.__raw = "nil";
        };
        flutter_path.__raw = "nil";
        flutter_lookup_cmd.__raw = ''
          (function()
            local exepath = vim.fn.exepath("flutter")
            local is_snap_installation = exepath and exepath:match("snap") or false
            return (require'flutter-tools.utils.path'.is_linux and is_snap_installation) and "flutter sdk-path" or nil
          end)()
        '';
        root_patterns = [
          ".git"
          "pubspec.yaml"
        ];
        fvm = false;
        widget_guides = {
          enabled = false;
        };
        closing_tags = {
          highlight = "Comment";
          prefix = "// ";
          priority = 10;
          enabled = true;
        };
        dev_log = {
          enabled = true;
          filter.__raw = "nil";
          notify_errors = false;
          open_cmd.__raw = "('botright %dvnew'):format(math.max(vim.o.columns * 0.4, 50))";
          focus_on_open = true;
        };
        dev_tools = {
          autostart = false;
          auto_open_browser = false;
        };
        outline = {
          open_cmd.__raw = "('botright %dvnew'):format(math.max(vim.o.columns * 0.3, 40))";
          auto_open = false;
        };
        lsp = {
          color = {
            enabled = false;
            background = false;
            background_color.__raw = "nil";
            foreground = false;
            virtual_text = true;
            virtual_text_str = "■";
          };
          on_attach.__raw = "nil";
          capabilities.__raw = "nil";
          settings.__raw = "nil";
        };
      };
    };
  };

  example = {
    plugins.flutter-tools = {
      enable = true;

      settings = {
        decorations = {
          statusline = {
            app_version = true;
            device = true;
          };
        };
        dev_tools = {
          autostart = true;
          auto_open_browser = true;
        };
        lsp.color.enabled = true;
        widget_guides.enabled = true;
        closing_tags = {
          highlight = "ErrorMsg";
          prefix = ">";
          priority = 10;
          enabled = false;
        };
      };
    };
  };
}
