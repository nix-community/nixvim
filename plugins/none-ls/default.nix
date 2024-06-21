{
  lib,
  helpers,
  config,
  options,
  pkgs,
  ...
}:
with lib;
helpers.neovim-plugin.mkNeovimPlugin config {
  name = "none-ls";
  originalName = "none-ls.nvim";
  luaName = "null-ls";
  defaultPackage = pkgs.vimPlugins.none-ls-nvim;

  maintainers = [ maintainers.MattSturgeon ];

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
      settingsPath = basePluginPath ++ [ "settings" ];
    in
    [
      ./servers.nix
      (mkRenamedOptionModule oldPluginPath basePluginPath)
      (mkRenamedOptionModule (basePluginPath ++ [ "sourcesItems" ]) (settingsPath ++ [ "sources" ]))
    ];

  # TODO:
  # settingsExample = {
  # };

  settingsOptions = import ./settings.nix { inherit helpers; };

  extraOptions = {
    enableLspFormat = mkOption {
      type = types.bool;
      # TODO: consider default = false and enabling lsp-format automatically instead?
      default = config.plugins.lsp-format.enable;
      defaultText = literalExpression "plugins.lsp-format.enable";
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
        // optionalAttrs (cfg.enableLspFormat && cfg.settings.on_attach == null) {
          on_attach = ''
            require('lsp-format').on_attach
          '';
        };

      # Summarize why lsp-format integration is enabled (used in warnings)
      enableLspFormatStatus =
        if options.plugins.none-ls.enableLspFormat.isDefined then
          "You have enabled the lsp-format integration with none-ls."
        else
          "The lsp-format integration with none-ls was enabled automatically, because `plugins.lsp-format` is enabled.";
    in
    {
      warnings = optional (cfg.enableLspFormat && cfg.settings.on_attach != null) ''
        ${enableLspFormatStatus}
        However, you have provided a custom value to `plugins.none-ls.settings.on_attach`.
        This means the `enableLspFormat` option will have no effect.
        Final value is:
        ${generators.toPretty { } cfg.settings.on_attach}
      '';

      assertions = [
        {
          assertion = cfg.enableLspFormat -> config.plugins.lsp-format.enable;
          message = ''
            Nixvim: ${enableLspFormatStatus}
            However, you have not enabled `plugins.lsp-format` itself.
            Note: `plugins.none-ls.enableLspFormat` is enabled by default when `plugins.lsp-format` is enabled.
            `plugins.none-ls.enableLspFormat` definitions: ${lib.options.showDefs options.plugins.none-ls.enableLspFormat.definitionsWithLocations}
          '';
        }
      ];

      # We only do this here because of enableLspFormat
      extraConfigLua = ''
        require("null-ls").setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
