{ lib, helpers }:
with lib;
{
  mkVimPlugin =
    {
      name,
      url ? if defaultPackage != null then defaultPackage.meta.homepage else null,
      maintainers,
      imports ? [ ],
      description ? null,
      # deprecations
      deprecateExtraConfig ? false,
      optionsRenamedToSettings ? [ ],
      # colorscheme
      isColorscheme ? false,
      colorscheme ? name,
      # options
      originalName ? name,
      defaultPackage ? null,
      settingsOptions ? { },
      settingsExample ? null,
      globalPrefix ? "",
      extraOptions ? { },
      # config
      extraConfig ? cfg: { },
      extraPlugins ? [ ],
      extraPackages ? [ ],
    }:
    let
      namespace = if isColorscheme then "colorschemes" else "plugins";

      # does this evaluate package?
      packageOption =
        if defaultPackage == null then
          { }
        else
          { package = helpers.mkPluginPackageOption name defaultPackage; };

      createSettingsOption = (isString globalPrefix) && (globalPrefix != "");

      settingsOption = optionalAttrs createSettingsOption {
        settings = helpers.mkSettingsOption {
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

      modules = [
        (
          { config, ... }:
          let
            cfg = config.${namespace}.${name};
          in
          {
            config = mkIf cfg.enable (mkMerge [
              {
                inherit extraPackages;
                globals = mapAttrs' (n: nameValuePair (globalPrefix + n)) (cfg.settings or { });
                # does this evaluate package? it would not be desired to evaluate package if we use another package.
                extraPlugins = extraPlugins ++ optional (defaultPackage != null) cfg.package;
              }
              (optionalAttrs (isColorscheme && (colorscheme != null)) { colorscheme = mkDefault colorscheme; })
              (extraConfig cfg)
            ]);
          }
        )
      ];
    in
    {
      meta = {
        inherit maintainers;
        nixvimInfo = {
          inherit description url;
          path = [
            namespace
            name
          ];
        };
      };
      options.${namespace}.${name} = {
        enable = mkEnableOption originalName;
      } // settingsOption // packageOption // extraOptions;

      imports =
        let
          basePluginPath = [
            namespace
            name
          ];
          settingsPath = basePluginPath ++ [ "settings" ];
        in
        imports
        ++ (optional (deprecateExtraConfig && createSettingsOption) (
          mkRenamedOptionModule (basePluginPath ++ [ "extraConfig" ]) settingsPath
        ))
        ++ (nixvim.mkSettingsRenamedOptionModules basePluginPath settingsPath optionsRenamedToSettings)
        ++ modules;

    };
}
