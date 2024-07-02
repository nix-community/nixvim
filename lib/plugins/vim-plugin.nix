{
  lib,
  nixvimOptions,
  nixvimUtils,
  mkPlugin,
}:
with lib;
{
  mkVimPlugin =
    config:
    {
      name,
      # deprecations
      deprecateExtraConfig ? false,
      # colorscheme
      isColorscheme ? false,
      colorscheme ? name,
      # options
      settingsOptions ? { },
      settingsExample ? null,
      globalPrefix ? "",
      extraOptions ? { },
      # config
      extraConfig ? cfg: { },
      ...
    }@args:
    mkPlugin config (
      let
        cfg = config.${namespace}.${name};

        globals = cfg.settings or { };

        createSettingsOption = (isString globalPrefix) && (globalPrefix != "");

        namespace = if isColorscheme then "colorschemes" else "plugins";

        settingsOption = optionalAttrs createSettingsOption {
          settings = nixvimOptions.mkSettingsOption {
            options = settingsOptions;
            example = settingsExample;
            description = ''
              The configuration options for **${name}** without the `${globalPrefix}` prefix.

              For example, the following settings are equivialent to these `:setglobal` commands:
              - `foo_bar = 1` -> `:setglobal ${globalPrefix}foo_bar=1`
              - `hello = "world"` -> `:setglobal ${globalPrefix}hello="world"`
              - `some_toggle = true` -> `:setglobal ${globalPrefix}some_toggle`
              - `other_toggle = false` -> `:setglobal no${globalPrefix}other_toggle`
            '';
          };
        };
      in
      (removeAttrs args [
        "deprecateExtraConfig"
        "extraConfig"
        "extraOptions"
        "globalPrefix"
        "imports"
        "settingsExample"
        "settingsOptions"
      ])
      // {
        imports =
          let
            basePluginPath = [
              namespace
              name
            ];
            settingsPath = basePluginPath ++ [ "settings" ];
          in
          (args.imports or [ ])
          ++ (optional (deprecateExtraConfig && createSettingsOption) (
            mkRenamedOptionModule (basePluginPath ++ [ "extraConfig" ]) settingsPath
          ));

        extraOptions = settingsOption // extraOptions;

        extraConfig =
          cfg:
          mkMerge (
            [ { globals = mapAttrs' (n: nameValuePair (globalPrefix + n)) globals; } ]
            ++ (optional (args ? extraConfig) (args.extraConfig cfg))
          );
      }
    );
}
