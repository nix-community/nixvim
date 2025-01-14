{
  lib,
  pkgs,
  config,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "flutter-tools";
  packPathName = "flutter-tools.nvim";
  package = "flutter-tools-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  extraOptions = {
    flutterPackage = lib.mkPackageOption pkgs "flutter" {
      nullable = true;
    };
  };
  extraConfig = cfg: {
    extraPackages = [ cfg.flutterPackage ];

    warnings =
      lib.optional
        (
          (cfg.settings ? debugger.enable)
          && (lib.isBool cfg.settings.debugger.enable)
          && cfg.settings.debugger.enable
          && (!config.plugins.dap.enable)
        )
        ''
          Nixvim (plugins.flutter-tools): You have enabled the dap integration (`settings.debugger.enable`) but `plugins.dap` is disabled.
        '';
  };

  settingsOptions = import ./settings-options.nix lib;

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
