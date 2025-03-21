{ lib, config, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "nerdy";
  packPathName = "nerdy.nvim";
  package = "nerdy-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  callSetup = false;
  hasSettings = false;

  extraOptions = {
    enableTelescope = lib.mkEnableOption "telescope integration";
  };

  extraConfig = cfg: {
    assertions = lib.nixvim.mkAssertions "plugins.git-worktree" {
      assertion = cfg.enableTelescope -> config.plugins.telescope.enable;
      message = ''
        You have to enable `plugins.telescope` as `enableTelescope` is activated.
      '';
    };
    plugins.telescope.enabledExtensions = lib.mkIf cfg.enableTelescope [ "nerdy" ];
  };
}
