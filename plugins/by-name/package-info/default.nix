{
  lib,
  pkgs,
  config,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "package-info";
  package = "package-info-nvim";
  description = "A Neovim plugin to manage npm/yarn/pnpm dependencies, commands and more.";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsExample = {
    icons.style = {
      up_to_date = "|  ";
      outdated = "|  ";
    };
    hide_up_to_date = true;
    package_manager = "npm";
  };

  extraOptions = {
    enableTelescope = lib.mkEnableOption "the `package_info` telescope picker.";

    packageManagerPackage =
      lib.mkPackageOption pkgs
        [
          "nodePackages"
          "npm"
        ]
        {
          nullable = true;
          default = null;
          example = "pkgs.nodePackages.npm";
        };
  };

  extraConfig = cfg: {
    assertions = lib.nixvim.mkAssertions "plugins.package-info" {
      assertion = cfg.enableTelescope -> config.plugins.telescope.enable;
      message = ''
        You have to enable `plugins.telescope` as `enableTelescope` is activated.
      '';
    };

    extraPackages = [ cfg.packageManagerPackage ];

    plugins.telescope.enabledExtensions = lib.mkIf cfg.enableTelescope [ "package_info" ];
  };
}
