{
  lib,
  nixvimOptions,
}:
with lib; {
  mkVimPlugin = config: {
    name,
    namespace ? "plugins",
    maintainers ? [],
    imports ? [],
    # options
    originalName ? name,
    package ? null,
    options ? {},
    settingsOptions ? {},
    settingsExample ? null,
    globalPrefix ? "",
    addExtraConfigRenameWarning ? false,
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
      if package == null
      then {}
      else {
        package = nixvimOptions.mkPackageOption name package;
      };

    createSettingsOption = (isString globalPrefix) && (globalPrefix != "");

    settingsOption =
      optionalAttrs createSettingsOption
      {
        settings = nixvimOptions.mkSettingsOption {
          options = settingsOptions;
          example = settingsExample;
          description = ''
            The configuration options for ${name} without the '${globalPrefix}' prefix.
            Example: To set '${globalPrefix}_foo_bar' to 1, write
            ```nix
              settings = {
                foo_bar = true;
              };
            ```
          '';
        };
      };
  in {
    meta.maintainers = maintainers;
    options.${namespace}.${name} =
      {
        enable = mkEnableOption originalName;
      }
      // settingsOption
      // packageOption
      // pluginOptions
      // extraOptions;

    imports =
      imports
      ++ optional (addExtraConfigRenameWarning && createSettingsOption) (
        mkRenamedOptionModule
        ["plugins" name "extraConfig"]
        ["plugins" name "settings"]
      );

    config =
      mkIf cfg.enable
      (
        mkMerge [
          {
            inherit extraPackages;
            globals = mapAttrs' (n: nameValuePair (globalPrefix + n)) globals;
            # does this evaluate package? it would not be desired to evaluate pacakge if we use another package.
            extraPlugins = extraPlugins ++ optional (package != null) cfg.package;
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
