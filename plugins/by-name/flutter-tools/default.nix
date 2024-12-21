{ lib, ... }:
let
  inherit (lib) types;
  inherit (lib.nixvim)
    defaultNullOpts
    literalLua
    mkNullOrOption'
    mkNullOrOption
    ;
in
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "flutter-tools";
  packPathName = "flutter-tools.nvim";
  package = "flutter-tools-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsOptions = {
    ui = {
      border = defaultNullOpts.mkNullable (with types; either str (listOf (maybeRaw str))) "rounded" ''
        The border type to use for all floating windows, the same options/formats used for
        `:h nvim_open_win` e.g. `"single"` | `"shadow"` | `[<list-of-eight-chars>]`.
      '';
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
          statusline this will show the currently selected project configuration.
        '';
      };
    };

    debugger = {
      enabled = defaultNullOpts.mkBool false ''
        Integrate with nvim `dap` + install dart code debugger.
      '';

      exception_breakpoints = defaultNullOpts.mkListOf types.anything [ ] ''
        If empty `dap` will not stop on any exceptions, otherwise it will stop on those specified.
        See `|:help dap.set_exception_breakpoints()|` for more info.
      '';

      evaluate_to_string_in_debug_views = defaultNullOpts.mkBool true ''
        Whether to call `toString()` on objects in debug views like hovers and the variables list.
        Invoking `toString()` has a performance cost and may introduce side-effects, although users
        may expected this functionality.
      '';

      register_configurations =
        defaultNullOpts.mkRaw
          ''
            function(paths)
              require("dap").configurations.dart = {
                --put here config that you would find in .vscode/launch.json
              }
              -- If you want to load .vscode launch.json automatically run the following:
            -- require("dap.ext.vscode").load_launchjs()
            end
          ''
          ''
            Function to register `dap` configurations.
          '';
    };

    flutter_path = defaultNullOpts.mkStr null ''
      Path to the `flutter` executable.
      This takes priority over the lookup
    '';

    flutter_lookup_cmd = mkNullOrOption' {
      example = "dirname $(which flutter)";
      description = ''
        The command used to locate the flutter path.
      '';
      type = types.str;
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
      highlight = defaultNullOpts.mkStr "ErrorMsg" ''
        Highlight group for the closing tag.
      '';

      prefix = defaultNullOpts.mkStr ">" ''
        Haracter to use for close tag e.g. > Widget.
      '';

      priority = defaultNullOpts.mkUnsignedInt 10 ''
        Priority of virtual text in current line.
      '';

      enabled = defaultNullOpts.mkBool true ''
        Consider to configure this when there is a possibility of multiple virtual text items in one
        line.
        See `priority` option in `|:help nvim_buf_set_extmark|` for more info.
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
        If there is an error whilst running then notify the user.
      '';

      open_cmd = defaultNullOpts.mkStr "15split" ''
        Command to use to open the log buffer.
      '';

      focus_on_open = defaultNullOpts.mkBool true ''
        Focus on the newly opened log window.
      '';
    };

    dev_tools = {
      autostart = defaultNullOpts.mkBool false ''
        Autostart devtools server if not detected.
      '';

      auto_open_browser = defaultNullOpts.mkBool false ''
        Automatically opens devtools in the browser.
      '';
    };

    outline = {
      open_cmd = defaultNullOpts.mkStr "30vnew" ''
        Command to use to open the outline buffer.
      '';

      auto_open = defaultNullOpts.mkBool false ''
        If `true` this will open the outline automatically when it is first populated.
      '';
    };

    lsp = {
      color = {
        enabled = defaultNullOpts.mkBool false ''
          Whether or not to highlight color variables at all, only supported on flutter >= 2.10.
        '';

        background = defaultNullOpts.mkBool false ''
          Whether to highlight the background.
        '';

        background_color = defaultNullOpts.mkAttrsOf' {
          type = types.ints.unsigned;
          pluginDefault = null;
          example = {
            r = 19;
            g = 17;
            b = 24;
          };
          description = ''
            Required when the background is transparent.
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
        The function to call when attaching the language server.
      '';

      capabilities = mkNullOrOption' {
        type = with types; attrsOf anything;
        example = literalLua ''
          function(config)
            config.specificThingIDontWant = false
            return config
          end
        '';
        description = ''
          LSP capabilities.
          You can use the ones of `lsp_status` or you can specify a function to deactivate or change
          or control how the config is created.
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
          LSP settings.
          See [here](https://github.com/dart-lang/sdk/blob/master/pkg/analysis_server/tool/lsp_spec/README.md#client-workspace-configuration)
          the link below for details on each option.
        '';
      };
    };
  };

  settingsExample = {
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
}
