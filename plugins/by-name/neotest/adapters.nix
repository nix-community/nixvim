{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib.nixvim) mkSettingsOption toLuaObject;
  supportedAdapters = import ./adapters-list.nix;

  mkAdapter =
    name:
    {
      treesitter-parser,
      packageName ? "neotest-${name}",
      settingsSuffix ? settingsLua: "(${settingsLua})",
    }:
    {
      options.plugins.neotest.adapters.${name} = {
        enable = lib.mkEnableOption name;

        package = lib.mkPackageOption pkgs name {
          default = [
            "vimPlugins"
            packageName
          ];
        };

        settings = mkSettingsOption { description = "settings for the `${name}` adapter."; };
      };

      config =
        let
          cfg = config.plugins.neotest.adapters.${name};
        in
        lib.mkIf cfg.enable {
          extraPlugins = [ cfg.package ];

          assertions = lib.nixvim.mkAssertions "plugins.neotest.adapters.${name}" {
            assertion = config.plugins.neotest.enable;
            message = ''
              You have to enable `plugins.neotest` to enable neotest adapters.
            '';
          };

          warnings = lib.nixvim.mkWarnings "plugins.neotest.adapters.${name}" {
            when = !config.plugins.treesitter.enable;

            message = ''
              This adapter requires `treesitter` to be enabled.
              You might want to set `plugins.treesitter.enable = true` and ensure that the `${treesitter-parser}` parser is enabled.
            '';
          };

          plugins.neotest.settings.adapters =
            let
              settingsString = lib.optionalString (cfg.settings != { }) (
                settingsSuffix (toLuaObject cfg.settings)
              );
            in
            [ "require('neotest-${name}')${settingsString}" ];
        };
    };
in
{
  imports = lib.mapAttrsToList mkAdapter supportedAdapters;
}
