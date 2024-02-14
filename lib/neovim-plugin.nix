{
  lib,
  nixvimOptions,
  toLuaObject,
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
    imports ? [],
    # options
    originalName ? name,
    defaultPackage,
    settingsOptions ? {},
    settingsExample ? null,
    extraOptions ? {},
    # config
    processSettings ? lib.id,
    luaName ? name,
    extraConfig ? cfg: {},
    extraPlugins ? [],
    extraPackages ? [],
  }: {
    meta.maintainers = maintainers;

    inherit imports;

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

            extraConfigLua = let
              finalSettings = processSettings cfg.settings;
            in ''
              require('${luaName}').setup(${toLuaObject finalSettings})
            '';
          }
          (extraConfig cfg)
        ]
      );
  };
}
