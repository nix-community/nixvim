{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "harpoon";
  package = "harpoon2";

  maintainers = [ lib.maintainers.GaetanLepage ];

  setup = ":setup";

  # TODO: introduced 2025-04-03: remove after 25.11
  imports = [
    ./deprecations.nix
  ];

  extraOptions = {
    enableTelescope = mkEnableOption "telescope integration";
  };

  settingsExample = {
    settings = {
      save_on_toggle = true;
      sync_on_ui_close = false;
    };
  };

  extraConfig = cfg: {
    assertions = lib.nixvim.mkAssertions "plugins.harpoon" {
      assertion = cfg.enableTelescope -> config.plugins.telescope.enable;
      message = "The harpoon telescope integration needs telescope to function as intended.";
    };

    plugins.telescope.enabledExtensions = lib.mkIf cfg.enableTelescope [ "harpoon" ];
  };
}
