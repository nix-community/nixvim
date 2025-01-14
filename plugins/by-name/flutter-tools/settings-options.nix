lib:
let
  inherit (lib) types;
  inherit (lib.nixvim)
    defaultNullOpts
    mkNullOrOption'
    mkNullOrOption
    literalLua
    ;
in
{
  ui = {
    border = defaultNullOpts.mkBorder' {
      pluginDefault = "single";
      example = "rounded";
      name = "all floating windows";
    };
  };

  decorations = {
    statusline = {
      app_version = defaultNullOpts.mkBool false ''
        Set to true to be able use the `flutter_tools_decorations.app_version` in your statusline.

        This will show the current version of the flutter app from the `pubspec.yaml` file.
      '';

      device = defaultNullOpts.mkBool false ''
        Set to true to be able use the `flutter_tools_decorations.device` in your statusline.

        This will show the currently running device if an application was started with a specific
        device.
      '';

      project_config = defaultNullOpts.mkBool false ''
        Set to true to be able use the `flutter_tools_decorations.project_config` in your
        statusline.

        This will show the currently selected project configuration.
      '';
    };
  };

  debugger = {
    enabled = defaultNullOpts.mkBool false ''
      Enable `nvim-dap` integration.
    '';

    exception_breakpoints = defaultNullOpts.mkListOf types.anything null ''
      If empty, dap will not stop on any exceptions.
      Otherwise it will stop on those specified.

      See `|:help dap.set_exception_breakpoints()|` for more information.
    '';

    evaluate_to_string_in_debug_views = defaultNullOpts.mkBool true ''
      Whether to call `toString()` on objects in debug views like hovers and the variables list.

      Invoking `toString()` has a performance cost and may introduce side-effects, although users
      may expect this functionality.
    '';

    register_configurations = defaultNullOpts.mkRaw' {
      pluginDefault = null;
      example = ''
        function(paths)
          require("dap").configurations.dart = {
            --put here config that you would find in .vscode/launch.json
          }
          -- If you want to load .vscode launch.json automatically run the following:
          -- require("dap.ext.vscode").load_launchjs()
        end
      '';
      description = ''
        Function to register configurations.
      '';
    };
  };

  flutter_path = defaultNullOpts.mkStr' {
    pluginDefault = null;
    example = "<full/path/if/needed>";
    description = ''
      Absolute path to the `flutter` binary.

      This takes priority over the `flutter_lookup_cmd`.
    '';
  };

  flutter_lookup_cmd = defaultNullOpts.mkStr' {
    pluginDefault = literalLua ''
      function get_default_lookup()
        local exepath = fn.exepath("flutter")
        local is_snap_installation = exepath and exepath:match("snap") or false
        return (path.is_linux and is_snap_installation) and "flutter sdk-path" or nil
      end
    '';
    example = "dirname $(which flutter)";
    description = ''
      The command used to find the directory where flutter is installed.
    '';
  };

  root_patterns = defaultNullOpts.mkListOf types.str [ ".git" "pubspec.yaml" ] ''
    Patterns to find the root of your flutter project.
  '';

  fvm = defaultNullOpts.mkBool false ''
    Takes priority over path, uses `<workspace>/.fvm/flutter_sdk` if enabled.
  '';

  widget_guides = {
    enabled = defaultNullOpts.mkBool false ''
      Whether to enable widget guides.
    '';
  };

  closing_tags = {
    highlight = defaultNullOpts.mkStr' {
      example = "ErrorMsg";
      pluginDefault = "Comment";
      description = ''
        Highlight group for the closing tag.
      '';
    };

    prefix = defaultNullOpts.mkStr' {
      pluginDefault = "// ";
      example = ">";
      description = ''
        Character to use for close tag.
      '';
    };

    priority = defaultNullOpts.mkUnsignedInt 10 ''
      Priority of virtual text in current line.

      Consider to configure this when there is a possibility of multiple virtual text items in one
      line.

      See `priority` option in `|:help nvim_buf_set_extmark|` for more information.
    '';

    enabled = defaultNullOpts.mkBool true ''
      Set to `false` to disable closing tags.
    '';
  };

  dev_log = {
    enabled = defaultNullOpts.mkBool true ''
      Whether to enable `dev_log`.
    '';

    filter = defaultNullOpts.mkRaw null ''
      Optional callback to filter the log.

      Takes a `log_line` as string argument; returns a boolean or `nil`.

      The `log_line` is only added to the output if the function returns `true`.
    '';

    notify_errors = defaultNullOpts.mkBool false ''
      Whether notify the user when there is an error whilst running.
    '';

    open_cmd = defaultNullOpts.mkStr' {
      example = "15split";
      pluginDefault = literalLua "('botright %dvnew'):format(math.max(vim.o.columns * 0.4, 50))";
      description = ''
        Command to use to open the log buffer.
      '';
    };

    focus_on_open = defaultNullOpts.mkBool true ''
      Whether to focus on the newly opened log window.
    '';
  };

  dev_tools = {
    autostart = defaultNullOpts.mkBool false ''
      Whether to autostart `devtools` server if not detected.
    '';

    auto_open_browser = defaultNullOpts.mkBool false ''
      Automatically opens `devtools` in the browser.
    '';
  };

  outline = {
    open_cmd = defaultNullOpts.mkStr' {
      pluginDefault = literalLua "('botright %dvnew'):format(math.max(vim.o.columns * 0.3, 40))";
      example = "30vnew";
      description = ''
        Command to use to open the outline buffer.
      '';
    };

    auto_open = defaultNullOpts.mkBool false ''
      If `true` this will open the outline automatically when it is first populated.
    '';
  };

  lsp = {
    color = {
      enabled = defaultNullOpts.mkBool false ''
        Show the derived colors for dart variables.
        Set this to `true` to enable color variables highlighting (only supported on
        flutter >= 2.10).
      '';

      background = defaultNullOpts.mkBool false ''
        Whether to highlight the background.
      '';

      background_color = defaultNullOpts.mkNullable' {
        type = with types; either str (attrsOf ints.unsigned);
        pluginDefault = null;
        example = {
          r = 19;
          g = 17;
          b = 24;
        };
        description = ''
          Background color.
          Required, when background is transparent.
        '';
      };

      foreground = defaultNullOpts.mkBool false ''
        Whether to highlight the foreground.
      '';

      virtual_text = defaultNullOpts.mkBool true ''
        Whether to show the highlight using virtual text.
      '';

      virtual_text_str = defaultNullOpts.mkStr "■" ''
        The virtual text character to highlight.
      '';
    };

    on_attach = mkNullOrOption types.rawLua ''
      Provide a custom `on_attach` function.
    '';

    capabilities = mkNullOrOption' {
      type = types.rawLua;
      example = literalLua ''
        function(config)
          config.specificThingIDontWant = false
          return config
        end
      '';
      description = ''
        Provide a custom value for `capabilities`.
        Example: `lsp_status` capabilities.
      '';
    };

    settings = mkNullOrOption' {
      type = with types; attrsOf anything;
      example = {
        showTodos = true;
        completeFunctionCalls = true;
        analysisExcludedFolders = [ "<path-to-flutter-sdk-packages>" ];
        renameFilesWithClasses = "prompt";
        enableSnippets = true;
        updateImportsOnRename = true;
      };
      description = ''
        Settings for the dart language server.
        See [here](https://github.com/dart-lang/sdk/blob/master/pkg/analysis_server/tool/lsp_spec/README.md#client-workspace-configuration)
        for details on each option.
      '';
    };
  };
}
