{
  lib,
  config,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "highlight-colors";
  packPathName = "nvim-highlight-colors";
  package = "nvim-highlight-colors";
  moduleName = "nvim-highlight-colors";
  description = "Highlight colors in Neovim buffers.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    render = "virtual";
    virtual_symbol = "■";
    enable_named_colors = true;
  };

  extraOptions = {
    cmpIntegration = lib.mkEnableOption "cmp-integration for nvim-highlight-colors.";
  };

  extraConfig = cfg: {
    opts.termguicolors = lib.mkDefault true;

    plugins.cmp.settings.formatting.format = lib.mkIf cfg.cmpIntegration (
      lib.nixvim.mkRaw "require('nvim-highlight-colors').format"
    );

    warnings = lib.nixvim.mkWarnings "plugins.highlight-colors" {
      when = cfg.cmpIntegration && !config.plugins.cmp.enable;
      message = ''
        You have enabled the cmp integration with highlight-colors but `plugins.cmp` is not enabled.
      '';
    };
  };
}
