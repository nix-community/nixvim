{
  lib,
  nixvimOptions,
  toLuaObject,
  nixvimUtils,
}:
with lib;
rec {
  mkSettingsOption =
    {
      pluginName ? null,
      options ? { },
      description ?
        if pluginName != null then
          "Options provided to the `require('${pluginName}').setup` function."
        else
          throw "mkSettingsOption: Please provide either a `pluginName` or `description`.",
      example ? null,
    }:
    nixvimOptions.mkSettingsOption { inherit options description example; };

  # TODO: DEPRECATED: use the `settings` option instead
  extraOptionsOptions = {
    extraOptions = mkOption {
      default = { };
      type = with types; attrsOf anything;
      description = ''
        These attributes will be added to the table parameter for the setup function.
        Typically, it can override NixVim's default settings.
      '';
    };
  };

  mkNeovimPlugin =
    config:
    {
      name,
      maintainers,
      url ? defaultPackage.meta.homepage,
      imports ? [ ],
      description ? null,
      # deprecations
      deprecateExtraOptions ? false,
      optionsRenamedToSettings ? [ ],
      # colorscheme
      isColorscheme ? false,
      colorscheme ? name,
      # options
      originalName ? name,
      defaultPackage,
      settingsOptions ? { },
      settingsExample ? null,
      extraOptions ? { },
      # config
      luaName ? name,
      extraConfig ? cfg: { },
      extraPlugins ? [ ],
      extraPackages ? [ ],
      callSetup ? true,
    }:
    let
      namespace = if isColorscheme then "colorschemes" else "plugins";
    in
    {
      meta = {
        inherit maintainers;
        nixvimInfo = {
          inherit description name url;
          kind = namespace;
        };
      };

      imports =
        let
          basePluginPath = [
            namespace
            name
          ];
          settingsPath = basePluginPath ++ [ "settings" ];
        in
        imports
        ++ (optional deprecateExtraOptions (
          mkRenamedOptionModule (basePluginPath ++ [ "extraOptions" ]) settingsPath
        ))
        ++ (map (
          option:
          let
            optionPath = if isString option then [ option ] else option; # option is already a path (i.e. a list)

            optionPathSnakeCase = map nixvimUtils.toSnakeCase optionPath;
          in
          mkRenamedOptionModule (basePluginPath ++ optionPath) (settingsPath ++ optionPathSnakeCase)
        ) optionsRenamedToSettings);

      options.${namespace}.${name} = {
        enable = mkEnableOption originalName;

        package = nixvimOptions.mkPackageOption originalName defaultPackage;

        settings = mkSettingsOption {
          pluginName = name;
          options = settingsOptions;
          example = settingsExample;
        };
      } // extraOptions;

      config =
        let
          cfg = config.${namespace}.${name};
          extraConfigNamespace = if isColorscheme then "extraConfigLuaPre" else "extraConfigLua";
        in
        mkIf cfg.enable (mkMerge [
          {
            extraPlugins = [ cfg.package ] ++ extraPlugins;
            inherit extraPackages;

            ${extraConfigNamespace} = optionalString callSetup ''
              require('${luaName}').setup(${toLuaObject cfg.settings})
            '';
          }
          (optionalAttrs (isColorscheme && (colorscheme != null)) { inherit colorscheme; })
          (extraConfig cfg)
        ]);
    };
}
