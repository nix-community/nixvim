{
  empty = {
    plugins.flutter-tools.enable = true;
  };

  defaults = {
    plugins.flutter-tools = {
      enable = true;

      settings = {
        ui = {
          border = "rounded";
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
          exception_breakpoints = [ ];
          evaluate_to_string_in_debug_views = true;
          register_configurations.__raw = ''
            function(paths)
              require("dap").configurations.dart = {
                --put here config that you would find in .vscode/launch.json
              }
              -- If you want to load .vscode launch.json automatically run the following:
            -- require("dap.ext.vscode").load_launchjs()
            end
          '';
        };
        flutter_path = null;
        flutter_lookup_cmd = null;
        root_patterns = [
          ".git"
          "pubspec.yaml"
        ];
        fvm = false;
        widget_guides = {
          enabled = false;
        };
        closing_tags = {
          highlight = "ErrorMsg";
          prefix = ">";
          priority = 10;
          enabled = true;
        };
        dev_log = {
          enabled = true;
          filter = null;
          notify_errors = false;
          open_cmd = "15split";
          focus_on_open = true;
        };
        dev_tools = {
          autostart = false;
          auto_open_browser = false;
        };
        outline = {
          open_cmd = "30vnew";
          auto_open = false;
        };
        lsp = {
          color = {
            enabled = false;
            background = false;
            background_color = null;
            foreground = false;
            virtual_text = true;
            virtual_text_str = "■";
          };
          on_attach = null;
          capabilities = null;
          settings = { };
        };
      };
    };
  };

  example = {
    plugins.flutter-tools = {
      enable = true;

      settings = {
        debugger = {
          enabled = true;
          run_via_dap = true;
        };
        widget_guides.enabled = false;
        closing_tags.highlight = "Comment";
        lsp = {
          on_attach = null;
          capabilities.__raw = ''
            function(config)
              config.documentFormattingProvider = false
              return config
            end
          '';
          settings = {
            enableSnippets = false;
            updateImportsOnRename = true;
          };
        };
      };
    };
  };
}
