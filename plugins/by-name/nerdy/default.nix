{ lib, config, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "nerdy";
  packPathName = "nerdy.nvim";
  package = "nerdy-nvim";
  description = "A Neovim plugin for searching, previewing, and inserting Nerd Font glyphs.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  callSetup = false;
  hasSettings = false;

  extraOptions = {
    enableTelescope = lib.mkEnableOption "telescope integration";
  };

  extraConfig = cfg: {
    assertions = lib.nixvim.mkAssertions "plugins.nerdy" {
      assertion = cfg.enableTelescope -> config.plugins.telescope.enable;
      message = ''
        Telescope support (enableTelescope) is enabled but the telescope plugin is not.
      '';
    };
    plugins.telescope.enabledExtensions = lib.mkIf cfg.enableTelescope [ "nerdy" ];
  };
}
