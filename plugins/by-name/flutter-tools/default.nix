{
  lib,
  config,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "flutter-tools";
  package = "flutter-tools-nvim";
  description = "Build flutter and dart applications in neovim using the native LSP.";

  maintainers = [ lib.maintainers.khaneliman ];

  dependencies = [ "flutter" ];

  imports = [
    # TODO: added 2025-04-07, remove after 25.05
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "flutter-tools";
      packageName = "flutter";
    })
  ];

  extraConfig = cfg: {
    warnings = lib.nixvim.mkWarnings "plugins.flutter-tools" {
      when =
        (cfg.settings ? debugger.enable)
        && (cfg.settings.debugger.enable == true)
        && (!config.plugins.dap.enable);

      message = ''
        You have enabled the dap integration (`settings.debugger.enable`) but `plugins.dap` is disabled.
      '';
    };
  };

  settingsOptions = import ./settings-options.nix lib;

  settingsExample = {
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
}
