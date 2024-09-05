{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib.nixvim) mkSettingsOption toSnakeCase;
  inherit (lib) mkPackageOption;
in
rec {
  mkExtension =
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
            optionPath = lib.toList option;

            optionPathSnakeCase = map toSnakeCase optionPath;
          in
          lib.mkRenamedOptionModule (basePluginPath ++ optionPath) (settingsPath ++ optionPathSnakeCase)
        ) optionsRenamedToSettings);

      options.plugins.telescope.extensions.${name} = {
        enable = lib.mkEnableOption "the `${name}` telescope extension";

        package = mkPackageOption pkgs name {
          default = [
            "vimPlugins"
            package
          ];
        };

        settings = mkSettingsOption {
          description = "settings for the `${name}` telescope extension.";
          options = settingsOptions;
          example = settingsExample;
        };
      } // extraOptions;

      config =
        let
          cfg = config.plugins.telescope.extensions.${name};
        in
        lib.mkIf cfg.enable (
          lib.mkMerge [
            {
              extraPlugins = [ cfg.package ];

              plugins.telescope = {
                enabledExtensions = [ extensionName ];
                settings.extensions.${extensionName} = cfg.settings;
              };
            }
            (extraConfig cfg)
          ]
        );
    };

  # FIXME: don't manually put Default in the description
  # TODO: Comply with #603
  mkModeMappingsOption =
    mode: defaults:
    lib.mkOption {
      type = with lib.types; attrsOf strLuaFn;
      default = { };
      description = ''
        Keymaps in ${mode} mode.

        Default:
        ```nix
          ${defaults}
        ```
      '';
      apply = lib.mapAttrs (_: lib.nixvim.mkRaw);
    };

  mkMappingsOption =
    { insertDefaults, normalDefaults }:
    {
      i = mkModeMappingsOption "insert" insertDefaults;
      n = mkModeMappingsOption "normal" normalDefaults;
    };
}
