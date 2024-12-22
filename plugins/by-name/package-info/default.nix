{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "package-info";
  packPathName = "package-info.nvim";
  package = "package-info-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsOptions = {
    autostart = defaultNullOpts.mkBool true ''
      Whether to autostart when `package.json` is opened.
    '';

    hide_up_to_date = defaultNullOpts.mkBool false ''
      It hides up to date versions when displaying virtual text.
    '';

    hide_unstable_versions = defaultNullOpts.mkBool false ''
      It hides unstable versions from version list e.g `next-11.1.3-canary3`.
    '';

    package_manager = defaultNullOpts.mkStr "npm" ''
      Can be `npm`, `yarn`, or `pnpm`.

      The plugin will try to auto-detect the package manager based on
      `yarn.lock` or `package-lock.json`.

      If none are found it will use the provided one, if nothing is provided it will use `npm`
    '';

    colors =
      defaultNullOpts.mkNullableWithRaw
        (
          with lib.types;
          submodule {
            freeformType = with types; attrsOf anything;
            options = {
              up_to_date = defaultNullOpts.mkStr "#3C4048" ''
                Text color for up to date dependency virtual text.
              '';
              outdated = defaultNullOpts.mkStr "#d19a66" ''
                Text color for outdated dependency virtual text.
              '';
              invalid = defaultNullOpts.mkStr "#ee4b2b" ''
                Text color for invalid dependency virtual text.
              '';
            };
          }
        )
        {
          up_to_date = "#3C4048";
          outdated = "#d19a66";
          invalid = "#ee4b2b";
        }
        "Colors of virtual text.";

    icons =
      defaultNullOpts.mkNullableWithRaw
        (
          with lib.types;
          either anything (submodule {
            freeformType = with types; attrsOf anything;
            options = {
              enable = defaultNullOpts.mkBool true ''
                Whether to display icons.
              '';
              style = defaultNullOpts.mkAttrsOf anything {
                up_to_date = "|  ";
                outdated = "|  ";
                invalid = "|  ";
              } "Icons for different dependency states.";
            };
          })
        )
        {
          enable = true;
          style = {
            up_to_date = "|  ";
            outdated = "|  ";
            invalid = "|  ";
          };
        }
        "Icons for virtual text.";
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
    assertions = [
      {
        assertion = cfg.enableTelescope -> config.plugins.telescope.enable;
        message = ''
          Nixvim (plugins.package-info): The telescope integration needs telescope to function as intended.
        '';
      }
    ];

    extraPackages = [ cfg.packageManagerPackage ];

    plugins.telescope.enabledExtensions = lib.mkIf cfg.enableTelescope [ "package_info" ];
  };
}
