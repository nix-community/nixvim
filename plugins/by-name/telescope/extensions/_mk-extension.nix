{
  name,
  package,
  extensionName ? name,
  settingsOptions ? { },
  settingsExample ? null,
  extraOptions ? { },
  imports ? [ ],
  optionsRenamedToSettings ? [ ],
  extraConfig ? cfg: { },
}:
let
  getPluginAttr = attrs: attrs.plugins.telescope.extensions.${name};

  renameModule =
    { lib, ... }:
    {
      # TODO remove this once all deprecation warnings will have been removed.
      imports =
        let
          basePluginPath = [
            "plugins"
            "telescope"
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
      options.plugins.telescope.extensions.${name} = {
        enable = lib.mkEnableOption "the `${name}` telescope extension";

        package = lib.mkPackageOption pkgs name {
          default = [
            "vimPlugins"
            package
          ];
        };

        settings = lib.nixvim.mkSettingsOption {
          description = "settings for the `${name}` telescope extension.";
          options = settingsOptions;
          example = settingsExample;
        };
      } // extraOptions;

      config = lib.mkIf cfg.enable {
        extraPlugins = [ cfg.package ];

        plugins.telescope = {
          enabledExtensions = [ extensionName ];
          settings.extensions.${extensionName} = cfg.settings;
        };
      };
    };

  extraConfigModule =
    {
      lib,
      config,
      options,
      ...
    }:
    lib.nixvim.modules.applyExtraConfig {
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
