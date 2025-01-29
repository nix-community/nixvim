{
  lib,
  config,
  options,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "none-ls";
  packPathName = "none-ls.nvim";
  moduleName = "null-ls";
  package = "none-ls-nvim";

  maintainers = [ lib.maintainers.MattSturgeon ];

  # TODO: introduced 2024-06-18, remove after 24.11
  deprecateExtraOptions = true;
  optionsRenamedToSettings = [
    "border"
    "cmd"
    "debounce"
    "debug"
    "defaultTimeout"
    "diagnosticConfig"
    "diagnosticsFormat"
    "fallbackSeverity"
    "logLevel"
    "notifyFormat"
    "onAttach"
    "onInit"
    "onExit"
    "rootDir"
    "shouldAttach"
    "tempDir"
    "updateInInsert"
    {
      old = "sourcesItems";
      new = "sources";
    }
  ];

  imports =
    let
      namespace = "plugins";
      oldPluginPath = [
        namespace
        "null-ls"
      ];
      basePluginPath = [
        namespace
        "none-ls"
      ];
    in
    [
      ./sources.nix
      (lib.mkRenamedOptionModule oldPluginPath basePluginPath)
    ];

  settingsExample = {
    diagnostics_format = "[#{c}] #{m} (#{s})";
    on_attach = ''
      function(client, bufnr)
        -- Integrate lsp-format with none-ls
        require('lsp-format').on_attach(client, bufnr)
      end
    '';
    on_exit = ''
      function()
        print("Goodbye, cruel world!")
      end
    '';
    on_init = ''
      function(client, initialize_result)
        print("Hello, world!")
      end
    '';
    root_dir = ''
      function(fname)
        return fname:match("my-project") and "my-project-root"
      end
    '';
    root_dir_async = ''
      function(fname, cb)
        cb(fname:match("my-project") and "my-project-root")
      end
    '';
    should_attach = ''
      function(bufnr)
        return not vim.api.nvim_buf_get_name(bufnr):match("^git://")
      end
    '';
    temp_dir = "/tmp";
    update_in_insert = false;
  };

  settingsOptions = import ./settings.nix lib;

  extraOptions = {
    enableLspFormat = lib.mkOption {
      type = lib.types.bool;
      # TODO: consider default = false and enabling lsp-format automatically instead?
      default = config.plugins.lsp-format.enable;
      defaultText = lib.literalExpression "plugins.lsp-format.enable";
      example = false;
      description = ''
        Automatically configure `none-ls` to use the `lsp-format` plugin.

        Enabled automatically when `plugins.lsp-format` is enabled.
        Set `false` to disable that behavior.
      '';
    };
  };

  callSetup = false;
  extraConfig =
    cfg:
    let
      # Set a custom on_attach when enableLspFormat is enabled
      # FIXME: Using `mkIf (...) (mkDefault "...")` would be better,
      # but that'd make it difficult to implement the "has no effect" warning.
      setupOptions =
        cfg.settings
        // lib.optionalAttrs (cfg.enableLspFormat && cfg.settings.on_attach == null) {
          on_attach.__raw = ''
            require('lsp-format').on_attach
          '';
        };
    in
    {
      warnings = lib.nixvim.mkWarnings "plugins.none-ls" {
        when = cfg.enableLspFormat && cfg.settings.on_attach != null;
        message = ''
          You have enabled the lsp-format integration with none-ls.
          However, you have provided a custom value to `plugins.none-ls.settings.on_attach`.
          This means the `enableLspFormat` option will have no effect.
          Final value is:
          ${lib.generators.toPretty { } cfg.settings.on_attach}
        '';
      };

      assertions = [
        {
          assertion = cfg.enableLspFormat -> config.plugins.lsp-format.enable;
          message = ''
            Nixvim: You have enabled the lsp-format integration with none-ls.
            However, you have not enabled `plugins.lsp-format` itself.
            Note: `plugins.none-ls.enableLspFormat` is enabled by default when `plugins.lsp-format` is enabled.
            `plugins.none-ls.enableLspFormat` definitions: ${lib.options.showDefs options.plugins.none-ls.enableLspFormat.definitionsWithLocations}
          '';
        }
      ];

      # We only do this here because of enableLspFormat
      plugins.none-ls.luaConfig.content = ''
        require("null-ls").setup(${lib.nixvim.toLuaObject setupOptions})
      '';
    };
}
