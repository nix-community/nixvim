{
  lib,
  nixvimOptions,
  toLuaObject,
  nixvimUtils,
}:
with lib; rec {
  mkSettingsOption = {
    pluginName ? null,
    options ? {},
    description ?
      if pluginName != null
      then "Options provided to the `require('${pluginName}').setup` function."
      else throw "mkSettingsOption: Please provide either a `pluginName` or `description`.",
    example ? null,
  }:
    nixvimOptions.mkSettingsOption {
      inherit options description example;
    };

  # TODO: DEPRECATED: use the `settings` option instead
  extraOptionsOptions = {
    extraOptions = mkOption {
      default = {};
      type = with types; attrsOf anything;
      description = ''
        These attributes will be added to the table parameter for the setup function.
        Typically, it can override NixVim's default settings.
      '';
    };
  };

  mkNeovimPlugin = config: {
    name,
    namespace ? "plugins",
    maintainers,
    url ? defaultPackage.meta.homepage,
    imports ? [],
    # deprecations
    deprecateExtraOptions ? false,
    optionsRenamedToSettings ? [],
    # options
    originalName ? name,
    defaultPackage,
    settingsOptions ? {},
    settingsExample ? null,
    extraOptions ? {},
    # config
    luaName ? name,
    extraConfig ? cfg: {},
    extraPlugins ? [],
    extraPackages ? [],
    callSetup ? true,
  }: {
    meta = {
      inherit maintainers;
      nixvimInfo = {
        inherit name url;
        kind = namespace;
      };
    };

    imports = let
      basePluginPath = [namespace name];
    in
      imports
      ++ (
        optional
        deprecateExtraOptions
        (
          mkRenamedOptionModule
          (basePluginPath ++ ["extraOptions"])
          (basePluginPath ++ ["settings"])
        )
      )
      ++ (
        map
        (
          optionName:
            mkRenamedOptionModule
            (basePluginPath ++ [optionName])
            (basePluginPath ++ ["settings" (nixvimUtils.toSnakeCase optionName)])
        )
        optionsRenamedToSettings
      );

    options.${namespace}.${name} =
      {
        enable = mkEnableOption originalName;

        package = nixvimOptions.mkPackageOption originalName defaultPackage;

        settings = mkSettingsOption {
          pluginName = name;
          options = settingsOptions;
          example = settingsExample;
        };
      }
      // extraOptions;

    config = let
      cfg = config.${namespace}.${name};
    in
      mkIf cfg.enable (
        mkMerge [
          {
            extraPlugins = [cfg.package] ++ extraPlugins;
            inherit extraPackages;

            extraConfigLua = optionalString callSetup ''
              require('${luaName}').setup(${toLuaObject cfg.settings})
            '';
          }
          (extraConfig cfg)
        ]
      );
  };
}
