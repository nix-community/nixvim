{
  lib,
  nixvimOptions,
  nixvimUtils,
}:
with lib;
{
  mkVimPlugin =
    config:
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

      cfg = config.${namespace}.${name};

      globals = cfg.settings or { };

      # does this evaluate package?
      packageOption =
        if defaultPackage == null then
          { }
        else
          { package = nixvimOptions.mkPluginPackageOption name defaultPackage; };

      createSettingsOption = (isString globalPrefix) && (globalPrefix != "");

      settingsOption = optionalAttrs createSettingsOption {
        settings = nixvimOptions.mkSettingsOption {
          options = settingsOptions;
          example = settingsExample;
          description = ''
            The configuration options for **${name}** without the `${globalPrefix}` prefix.

            Example: To set `${globalPrefix}foo_bar` to `1`, write
            ```nix
              settings = {
                foo_bar = true;
              };
            ```
          '';
        };
      };
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
        ++ (map (
          option:
          let
            optionPath = if isString option then [ option ] else option; # option is already a path (i.e. a list)

            optionPathSnakeCase = map nixvimUtils.toSnakeCase optionPath;
          in
          mkRenamedOptionModule (basePluginPath ++ optionPath) (settingsPath ++ optionPathSnakeCase)
        ) optionsRenamedToSettings);

      config = mkIf cfg.enable (mkMerge [
        {
          inherit extraPackages;
          globals = mapAttrs' (n: nameValuePair (globalPrefix + n)) globals;
          # does this evaluate package? it would not be desired to evaluate package if we use another package.
          extraPlugins = extraPlugins ++ optional (defaultPackage != null) cfg.package;
        }
        (optionalAttrs (isColorscheme && (colorscheme != null)) { colorscheme = mkDefault colorscheme; })
        (extraConfig cfg)
      ]);
    };
}
