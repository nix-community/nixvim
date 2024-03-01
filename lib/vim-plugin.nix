{
  lib,
  nixvimOptions,
  nixvimUtils,
}:
with lib; {
  mkVimPlugin = config: {
    name,
    namespace ? "plugins",
    url ?
      if defaultPackage != null
      then defaultPackage.meta.homepage
      else null,
    maintainers ? [],
    imports ? [],
    # deprecations
    deprecateExtraConfig ? false,
    optionsRenamedToSettings ? [],
    # options
    originalName ? name,
    defaultPackage ? null,
    options ? {},
    settingsOptions ? {},
    settingsExample ? null,
    globalPrefix ? "",
    extraOptions ? {},
    # config
    extraConfig ? cfg: {},
    extraPlugins ? [],
    extraPackages ? [],
  }: let
    cfg = config.${namespace}.${name};

    # TODO support nested options!
    pluginOptions =
      mapAttrs
      (
        optName: opt:
          opt.option
      )
      options;

    globalsFromOptions =
      mapAttrs'
      (optName: opt: {
        name =
          if opt.global == null
          then optName
          else opt.global;
        value = cfg.${optName};
      })
      options;
    globalsFromSettings =
      if (hasAttr "settings" cfg) && (cfg.settings != null)
      then cfg.settings
      else {};
    globals = globalsFromOptions // globalsFromSettings;

    # does this evaluate package?
    packageOption =
      if defaultPackage == null
      then {}
      else {
        package = nixvimOptions.mkPackageOption name defaultPackage;
      };

    createSettingsOption = (isString globalPrefix) && (globalPrefix != "");

    settingsOption =
      optionalAttrs createSettingsOption
      {
        settings = nixvimOptions.mkSettingsOption {
          options = settingsOptions;
          example = settingsExample;
          description = ''
            The configuration options for **${name}** without the `${globalPrefix}` prefix.

            Example: To set '${globalPrefix}foo_bar' to 1, write
            ```nix
              settings = {
                foo_bar = true;
              };
            ```
          '';
        };
      };
  in {
    meta = {
      inherit maintainers;
      nixvimInfo = {
        inherit name url;
        kind = namespace;
      };
    };
    options.${namespace}.${name} =
      {
        enable = mkEnableOption originalName;
      }
      // settingsOption
      // packageOption
      // pluginOptions
      // extraOptions;

    imports = let
      basePluginPath = [namespace name];
      settingsPath = basePluginPath ++ ["settings"];
    in
      imports
      ++ (
        optional
        (deprecateExtraConfig && createSettingsOption)
        (
          mkRenamedOptionModule
          (basePluginPath ++ ["extraConfig"])
          settingsPath
        )
      )
      ++ (
        map
        (
          option: let
            optionPath =
              if isString option
              then [option]
              else option; # option is already a path (i.e. a list)

            optionPathSnakeCase = map nixvimUtils.toSnakeCase optionPath;
          in
            mkRenamedOptionModule
            (basePluginPath ++ optionPath)
            (settingsPath ++ optionPathSnakeCase)
        )
        optionsRenamedToSettings
      );

    config =
      mkIf cfg.enable
      (
        mkMerge [
          {
            inherit extraPackages;
            globals = mapAttrs' (n: nameValuePair (globalPrefix + n)) globals;
            # does this evaluate package? it would not be desired to evaluate pacakge if we use another package.
            extraPlugins = extraPlugins ++ optional (defaultPackage != null) cfg.package;
          }
          (extraConfig cfg)
        ]
      );
  };

  mkDefaultOpt = {
    type,
    global ? null,
    description ? null,
    example ? null,
    default ? null,
    ...
  }: {
    option = mkOption {
      type = types.nullOr type;
      inherit default description example;
    };

    inherit global;
  };
}
