# snatched from telescope's _mk-extension.nix
{
  name,
  package,
  extensionName ? name,
  dependencies ? [ ],
  settingsOptions ? { },
  settingsExample ? null,
  extraOptions ? { },
  imports ? [ ],
  optionsRenamedToSettings ? [ ],
  extraConfig ? cfg: { },
}:
let
  getPluginAttr = attrs: attrs.plugins.codecompanion.extensions.${name};

  renameModule =
    { lib, ... }:
    {
      # TODO remove this once all deprecation warnings will have been removed.
      imports =
        let
          basePluginPath = [
            "plugins"
            "codecompanion"
            "extensions"
            name
          ];
          settingsPath = basePluginPath ++ [ "settings" ];
        in
        lib.nixvim.mkSettingsRenamedOptionModules basePluginPath settingsPath optionsRenamedToSettings;
    };

  module =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      cfg = getPluginAttr config;
    in
    {
      options.plugins.codecompanion.extensions.${name} = {
        enable = lib.mkEnableOption "the `${name}` codecompanion extension";

        package = lib.mkPackageOption pkgs name {
          default = [
            "vimPlugins"
            package
          ];
        };

        settings = lib.nixvim.mkSettingsOption {
          description = "settings for the `${name}` codecompanion extension.";
          options = settingsOptions;
          example = settingsExample;
        };
      }
      // extraOptions;

      config = lib.mkIf cfg.enable (
        lib.mkMerge [
          {
            extraPlugins = [ cfg.package ];

            plugins.codecompanion = {
              settings.extensions.${extensionName} = cfg.settings;
            };
          }
          (lib.nixvim.plugins.utils.enableDependencies dependencies)
        ]
      );
    };

  extraConfigModule =
    {
      lib,
      config,
      options,
      ...
    }:
    lib.nixvim.plugins.utils.applyExtraConfig {
      inherit extraConfig;
      cfg = getPluginAttr config;
      opts = getPluginAttr options;
    };
in
{
  imports = imports ++ [
    module
    extraConfigModule
    renameModule
  ];
}
