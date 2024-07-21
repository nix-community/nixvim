{
  lib,
  nixvimOptions,
  toLuaObject,
  nixvimUtils,
}:
with lib;
{
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
      settingsDescription ? "Options provided to the `require('${luaName}')${setup}` function.",
      hasSettings ? true,
      extraOptions ? { },
      # config
      luaName ? name,
      setup ? ".setup",
      extraConfig ? cfg: { },
      extraPlugins ? [ ],
      extraPackages ? [ ],
      callSetup ? true,
      installPackage ? true,
    }:
    let
      namespace = if isColorscheme then "colorschemes" else "plugins";
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

      options.${namespace}.${name} =
        {
          enable = mkEnableOption originalName;

          package = nixvimOptions.mkPluginPackageOption originalName defaultPackage;
        }
        // optionalAttrs hasSettings {
          settings = nixvimOptions.mkSettingsOption {
            description = settingsDescription;
            options = settingsOptions;
            example = settingsExample;
          };
        }
        // extraOptions;

      config =
        let
          cfg = config.${namespace}.${name};
          extraConfigNamespace = if isColorscheme then "extraConfigLuaPre" else "extraConfigLua";
        in
        mkIf cfg.enable (mkMerge [
          {
            extraPlugins = (optional installPackage cfg.package) ++ extraPlugins;
            inherit extraPackages;
          }
          (optionalAttrs callSetup {
            ${extraConfigNamespace} = ''
              require('${luaName}')${setup}(${optionalString (cfg ? settings) (toLuaObject cfg.settings)})
            '';
          })
          (optionalAttrs (isColorscheme && (colorscheme != null)) { colorscheme = mkDefault colorscheme; })
          (extraConfig cfg)
        ]);
    };
}
