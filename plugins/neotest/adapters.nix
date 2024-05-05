{
  lib,
  config,
  helpers,
  pkgs,
  ...
}:
with lib;
let
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
        enable = mkEnableOption name;

        package = helpers.mkPackageOption name pkgs.vimPlugins.${packageName};

        settings = helpers.mkSettingsOption { description = "settings for the `${name}` adapter."; };
      };

      config =
        let
          cfg = config.plugins.neotest.adapters.${name};
        in
        mkIf cfg.enable {
          extraPlugins = [ cfg.package ];

          warnings = optional (!config.plugins.treesitter.enable) ''
            Nixvim (plugins.neotest.adapters.${name}): This adapter requires `treesitter` to be enabled.
            You might want to set `plugins.treesitter.enable = true` and ensure that the `${props.treesitter-parser}` parser is enabled.
          '';

          plugins.neotest.settings.adapters =
            let
              settingsString = optionalString (cfg.settings != { }) (
                settingsSuffix (helpers.toLuaObject cfg.settings)
              );
            in
            [ "require('neotest-${name}')${settingsString}" ];
        };
    };
in
{
  imports = mapAttrsToList mkAdapter supportedAdapters;
}
