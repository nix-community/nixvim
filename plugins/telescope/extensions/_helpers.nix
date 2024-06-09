{
  lib,
  config,
  helpers,
  ...
}:
with lib;
rec {
  mkExtension =
    {
      name,
      defaultPackage,
      extensionName ? name,
      settingsOptions ? { },
      settingsExample ? null,
      extraOptions ? { },
      imports ? [ ],
      optionsRenamedToSettings ? [ ],
      extraConfig ? cfg: { },
    }:
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
        imports
        ++ (map (
          option:
          let
            optionPath = if isString option then [ option ] else option; # option is already a path (i.e. a list)

            optionPathSnakeCase = map helpers.toSnakeCase optionPath;
          in
          mkRenamedOptionModule (basePluginPath ++ optionPath) (settingsPath ++ optionPathSnakeCase)
        ) optionsRenamedToSettings);

      options.plugins.telescope.extensions.${name} = {
        enable = mkEnableOption "the `${name}` telescope extension";

        package = helpers.mkPluginPackageOption name defaultPackage;

        settings = helpers.mkSettingsOption {
          description = "settings for the `${name}` telescope extension.";
          options = settingsOptions;
          example = settingsExample;
        };
      } // extraOptions;

      config =
        let
          cfg = config.plugins.telescope.extensions.${name};
        in
        mkIf cfg.enable (mkMerge [
          {
            extraPlugins = [ cfg.package ];

            plugins.telescope = {
              enabledExtensions = [ extensionName ];
              settings.extensions.${extensionName} = cfg.settings;
            };
          }
          (extraConfig cfg)
        ]);
    };

  mkModeMappingsOption =
    mode: defaults:
    mkOption {
      type = with helpers.nixvimTypes; attrsOf strLuaFn;
      default = { };
      description = helpers.defaultNullOpts.mkDesc defaults ''
        Keymaps in ${mode} mode.
      '';
      apply = mapAttrs (_: helpers.mkRaw);
    };

  mkMappingsOption =
    { insertDefaults, normalDefaults }:
    {
      i = mkModeMappingsOption "insert" insertDefaults;
      n = mkModeMappingsOption "normal" normalDefaults;
    };
}
